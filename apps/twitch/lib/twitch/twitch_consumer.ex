defmodule Twitch.TwitchConsumer do
  use GenStage

  def start_link(arg) do
    GenStage.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    # {:consumer, state, subscribe_to: []}
    state = :no_state
    {:consumer, state, subscribe_to: [Twitch.TwitchProducer]}
  end

  # Receive events from Producer
  # Trigger application logic
  def handle_events(events, _from, state) do
    for event <- events do
      IO.inspect(event)

      %Client.TwitchEvent{}
      |> Client.TwitchEvent.changeset(Map.from_struct(event))
      |> Client.Repo.insert()

      # IO.puts "#{event["display-name"]}: #{event["message"]}"
    end

    # Consumers do not emit events
    {:noreply, [], state}
  end
end
