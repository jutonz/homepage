defmodule Evented.TwitchProducer do
  use GenStage

  def start_link(initial \\ 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter) do
    {:producer, counter}
  end

  # Public API to publish an event
  def publish(event) do
    GenServer.cast(__MODULE__, {:add, event})
  end

  def handle_cast({:add, event}, state) do
    {:noreply, [event], state}
  end

  # Ignore demand
  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end
