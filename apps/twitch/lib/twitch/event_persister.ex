defmodule Twitch.EventPersister do
  use GenServer

  @persist_after 10

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    state = []

    :ok = EventBus.register_topic(:chat_message)
    EventBus.subscribe({__MODULE__, ["chat_message"]})

    {:ok, state}
  end

  def process(event) do
    GenServer.cast(__MODULE__, event)
  end

  def handle_cast({topic, id} = event_shadow, state) do
    event = EventBus.fetch_event(event_shadow)
    struct = event.data |> Map.from_struct()
    cset = %Twitch.TwitchEvent{} |> Twitch.TwitchEvent.changeset(struct)
    events = Enum.concat(state, [cset])

    new_state =
      if length(events) >= @persist_after do
        events |> Enum.each(&Twitch.Repo.insert(&1))
        []
      else
        events
      end

    EventBus.mark_as_completed({__MODULE__, event_shadow})

    {:noreply, new_state}
  end
end
