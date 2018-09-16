defmodule Twitch.TwitchProducer do
  use GenStage

  def start_link(arg) do
    GenStage.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    state = :no_state
    {:producer, state}
  end

  # Public API to publish an event
  def publish(event) do
    GenServer.cast(__MODULE__, {:add, event})
  end

  def handle_cast({:add, event}, state) do
    IO.puts("TwitchProducer: #{event.message}")
    {:noreply, [event], state}
  end

  # Ignore demand
  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end
