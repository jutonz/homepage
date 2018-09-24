defmodule Twitch.EventPersister do
  use GenServer

  @persist_after 10

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

  # Ignore these commands
  def make_state(%{irc_command: "MODE"}, state), do: state
  def make_state(%{irc_command: "GLOBALUSERSTATE"}, state), do: state

  # Create changest and add to state
  def make_state(event_struct, state) do
    cset = %Twitch.TwitchEvent{} |> Twitch.TwitchEvent.changeset(event_struct)
    events = Enum.concat(state, [cset])

    if length(events) >= @persist_after do
      events |> Enum.each(&Twitch.Repo.insert(&1))
      []
    else
      events
    end
  end

  def handle_cast({_topic, _id} = event_shadow, state) do
    event = Events.fetch_event(event_shadow)

    struct = event.data |> Map.from_struct()
    new_state = make_state(struct, state)

    Events.mark_as_completed({__MODULE__, event_shadow})

    {:noreply, new_state}
  end
end
