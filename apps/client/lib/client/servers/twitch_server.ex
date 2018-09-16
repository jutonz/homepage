defmodule Client.TwitchServer do
  use GenStage

  def start_link(arg) do
    GenStage.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    {:consumer, :no_state, subscribe_to: [Twitch.TwitchProducer]}
  end

  def handle_events(events, _from, state) do
    events
    |> Enum.each(fn event ->
      ClientWeb.Endpoint.broadcast!("twitch_channel:#{event.channel}", event.irc_command, event)
    end)

    # Consumers do not emit events
    {:noreply, [], state}
  end
end
