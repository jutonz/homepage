defmodule Twitch.EventPersister do
  use GenServer

  @persist_after 10

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    state = %{channels: %{}, events: []}

    Events.subscribe({__MODULE__, ["chat_message"]})

    {:ok, state}
  end

  def process(event) do
    GenServer.cast(__MODULE__, event)
  end

  # Ignore these commands
  def update_state(%{irc_command: "MODE"}, state), do: state
  def update_state(%{irc_command: "GLOBALUSERSTATE"}, state), do: state
  def update_state(%{irc_command: "CAP"}, state), do: state
  def update_state(%{irc_command: "353"}, state), do: state

  def update_state(event_struct, state) do
    channels = update_channels(event_struct, state[:channels])
    events = update_events(event_struct, state[:events], channels)

    %{
      events: events,
      channels: channels
    }
  end

  def update_channels(event_struct, channels) do
    channel_name = event_struct[:channel]

    {_, new_channels} =
      channels
      |> Map.get_and_update(channel_name, fn current_value ->
        if is_nil(current_value) do
          {current_value, channel_state_struct(channel_name)}
        else
          {current_value, current_value}
        end
      end)

    new_channels
  end

  def channel_state_struct(channel_name) do
    channel = Twitch.Channel |> Twitch.Repo.get_by(name: channel_name)

    %{
      persist: channel.persist
    }
  end

  def update_events(event_struct, events, channels) do
    events = add_event_struct_to_state(event_struct, events, channels)

    if length(events) >= @persist_after do
      events |> Enum.each(&persist_event/1)
      []
    else
      events
    end
  end

  def add_event_struct_to_state(event_struct, events, channels) do
    if should_persist_event?(event_struct, channels) do
      Enum.concat(events, [event_struct])
    else
      events
    end
  end

  def should_persist_event?(event_struct, channels) do
    channel_name = event_struct[:channel]
    channel_struct = channels[channel_name]
    Map.get(channel_struct, :persist, false)
  end

  def persist_event(event) do
    {:ok, parsed_event} = Twitch.ParsedEvent.from_raw(event.raw_event)

    case parsed_event |> Twitch.Datastore.ChatEvent.persist_event() do
      {:ok, _key} ->
        ev = struct(Twitch.TwitchEvent, event)
        Events.publish(ev, :twitch_event_created)

      _ ->
        nil
    end
  end

  def handle_cast({_topic, _id} = event_shadow, state) do
    event = Events.fetch_event(event_shadow)

    struct = event.data |> Map.from_struct()
    new_state = update_state(struct, state)

    Events.mark_as_completed({__MODULE__, event_shadow})

    {:noreply, new_state}
  end
end
