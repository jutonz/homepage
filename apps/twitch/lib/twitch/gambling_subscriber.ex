defmodule Twitch.GamblingSubscriber do
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    state = []

    Events.subscribe({__MODULE__, ["chat_message"]})

    {:ok, state}
  end

  def process(event) do
    GenServer.cast(__MODULE__, event)
  end

  def handle_cast({_topic, _id} = event_shadow, state) do
    event = Events.fetch_event(event_shadow)
    struct = event.data |> Map.from_struct()

    if res = Twitch.Gambling.gambling?(struct) do
      IO.inspect(res)
    end

    {:noreply, state}
  end
end
