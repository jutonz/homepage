defmodule Evented.TwitchConsumer do
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :state_doesnt_matter, name: __MODULE__)
  end

  def init(state) do
    # {:consumer, state, subscribe_to: []}
    {:consumer, state, subscribe_to: [Evented.TwitchProducer]}
  end

  # Receive events from Producer
  # Trigger application logic
  def handle_events(events, _from, state) do
    for event <- events do
      IO.inspect(event)
      # IO.puts "#{event["display-name"]}: #{event["message"]}"
    end

    # Consumers do not emit events
    {:noreply, [], state}
  end
end
