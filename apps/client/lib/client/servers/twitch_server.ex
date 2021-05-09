defmodule Client.TwitchServer do
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    Events.subscribe({__MODULE__, ["chat_message", "twitch_emote"]})
    {:ok, :no_state}
  end

  def process(event) do
    GenServer.cast(__MODULE__, event)
  end

  def handle_cast({:chat_message, _id} = event_shadow, state) do
    event = Events.fetch_event(event_shadow).data

    Phoenix.PubSub.broadcast!(
      Client.PubSub,
      "chat_message:#{event.channel}",
      event
    )

    ClientWeb.Endpoint.broadcast!(
      "twitch_channel:#{event.channel}",
      event.irc_command,
      event
    )

    {:noreply, state}
  end

  def handle_cast({:twitch_emote, _id} = event_shadow, state) do
    event = Events.fetch_event(event_shadow).data

    channel_name = event[:channel_name]
    one_minute_window = event[:one_minute_window]

    ClientWeb.Endpoint.broadcast!(
      "twitch_emote:#{channel_name}",
      "one_minute_window",
      one_minute_window
    )

    Events.mark_as_completed({__MODULE__, event_shadow})

    {:noreply, state}
  end
end
