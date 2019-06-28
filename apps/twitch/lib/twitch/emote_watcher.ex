defmodule Twitch.EmoteWatcher do
  use GenServer
  alias Twitch.Bttv

  @one_minute 60000

  def start_link([channel]) do
    name = Twitch.Channel.emote_watcher_name(channel)
    GenServer.start_link(__MODULE__, [name, channel], name: name)
  end

  def init([name, "#" <> channel_name]) do
    Events.subscribe({__MODULE__, ["chat_message"]})

    channel_id = Twitch.Api.channel(channel_name)["_id"]

    state = %{
      channel_emotes: Twitch.Api.channel_emotes(channel_name),
      global_emotes: Twitch.Api.global_emotes(),
      bttv_channel_emotes: Twitch.Bttv.channel_emotes(channel_name),
      bttv_global_emotes: Twitch.Bttv.global_emotes(),
      ffz_global_emotes: Twitch.Bttv.global_ffz_emotes(),
      ffz_channel_emotes: Twitch.Bttv.channel_ffz_emotes(channel_id),
      one_minute_window: %{},
      name: name,
      channel_name: channel_name
    }

    {:ok, state}
  end

  def process(event_shadow) do
    event = Events.fetch_event(event_shadow).data

    if event.channel && event.message do
      name = Twitch.Channel.emote_watcher_name(event.channel)
      GenServer.cast(name, event_shadow)
    end
  end

  def emotes_in_message(message, state) do
    %{}
    |> Map.merge(Twitch.Emote.detect_many(state[:global_emotes], message))
    |> Map.merge(Twitch.Emote.detect_many(state[:channel_emotes], message))
    |> Map.merge(Bttv.Emote.detect_many(state[:bttv_channel_emotes], message))
    |> Map.merge(Bttv.Emote.detect_many(state[:bttv_global_emotes], message))
    |> Map.merge(Bttv.Emote.detect_many(state[:ffz_global_emotes], message))
    |> Map.merge(Bttv.Emote.detect_many(state[:ffz_channel_emotes], message))
  end

  def handle_cast({_topic, _id} = event_shadow, state) do
    event = Events.fetch_event(event_shadow).data

    emotes_in_msg = emotes_in_message(event.message, state)

    new_one_minute_window =
      state
      |> Map.get(:one_minute_window)
      |> Enum.reduce(emotes_in_msg, fn {emote_code, _count}, result ->
        current_count = state[:one_minute_window][emote_code]
        seen_just_now = emotes_in_msg |> Map.get(emote_code, 0)
        new_count = current_count + seen_just_now

        result |> Map.put(emote_code, new_count)
      end)

    emotes_in_msg
    |> Enum.each(fn {emote_code, count} ->
      schedule_decrement(:one_minute_window, emote_code, count, @one_minute)
    end)

    new_state = state |> Map.merge(%{one_minute_window: new_one_minute_window})

    broadcast(new_state)

    {:noreply, new_state}
  end

  def handle_info({:decrement, bucket, emote, amount}, state) do
    {_, new_bucket} =
      state[bucket]
      |> Map.get_and_update(emote, fn current ->
        {current, current - amount}
      end)

    new_bucket =
      if new_bucket[emote] == 0 do
        new_bucket |> Map.delete(emote)
      else
        new_bucket
      end

    new_state = state |> Map.merge(%{bucket => new_bucket})

    broadcast(new_state)

    {:noreply, new_state}
  end

  def schedule_decrement(bucket, emote, amount, after_ms) do
    Process.send_after(
      self(),
      {:decrement, bucket, emote, amount},
      after_ms
    )
  end

  def broadcast(state) do
    event = %{
      channel_name: state[:channel_name],
      one_minute_window: state[:one_minute_window]
    }

    Events.publish(event, :twitch_emote)
  end
end
