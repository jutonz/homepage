defmodule Client.TwitchServer do
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    Events.subscribe({__MODULE__, ["chat_message"]})
    {:ok, :no_state}
  end

  def process(event) do
    GenServer.cast(__MODULE__, event)
  end

  def handle_cast({_topic, _id} = event_shadow, state) do
    event = Events.fetch_event(event_shadow).data

    ClientWeb.Endpoint.broadcast!(
      "twitch_channel:#{event.channel}",
      event.irc_command,
      event
    )

    # Events.mark_as_completed({__MODULE__, event_shadow})

    {:noreply, state}
  end
end
