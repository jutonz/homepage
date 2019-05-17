defmodule Twitch.GamblingSubscriber do
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    state = []

    Events.subscribe({__MODULE__, ["twitch_event_created"]})

    {:ok, state}
  end

  def process(event) do
    GenServer.cast(__MODULE__, event)
  end

  def handle_cast({_topic, _id} = event_shadow, state) do
    event = Events.fetch_event(event_shadow)
    {:ok, parsed} = parsed = event.data.raw_event |> Twitch.ParsedEvent.from_raw()

    if res = Twitch.Gambling.gambling?(parsed) do
      {gamble_type, won, _ev} = res

      %Twitch.GamblingEvent{
        gamble_type: to_string(gamble_type),
        won: won == :won,
        twitch_event: event.data,
        channel: event.data.channel
      }
      |> Twitch.GamblingEvent.changeset()
      |> Twitch.GoogleRepo.insert()
    end

    Events.mark_as_completed({__MODULE__, event_shadow})

    {:noreply, state}
  end
end
