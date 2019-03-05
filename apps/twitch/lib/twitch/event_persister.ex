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
  def update_state(%{irc_command: "MODE"}, state), do: state
  def update_state(%{irc_command: "GLOBALUSERSTATE"}, state), do: state
  def update_state(%{irc_command: "CAP"}, state), do: state
  def update_state(%{irc_command: "353"}, state), do: state

  # Create changest and add to state
  def update_state(event_struct, state) do
    events = add_event_struct_to_state(event_struct, state)

    if length(events) >= @persist_after do
      events |> Enum.each(&persist_event/1)
      []
    else
      events
    end
  end

  def add_event_struct_to_state(event_struct, state) do
    if should_persist_event?(event_struct) do
      cset = %Twitch.TwitchEvent{} |> Twitch.TwitchEvent.changeset(event_struct)
      Enum.concat(state, [cset])
    else
      state
    end
  end

  def should_persist_event?(event_struct) do
    true
  end

  def persist_event(event) do
    case event |> Twitch.Repo.insert() do
      {:ok, ev} ->
        Events.publish(ev, :twitch_event_created)

      _ ->
        nil
    end
  end

  def handle_cast({_topic, _id} = event_shadow, state) do
    event = Events.fetch_event(event_shadow)

    struct = event.data |> Map.from_struct()
    new_state = update_state(struct, state)

    Events.mark_as_completed({__MODULE__, event_shadow})

    {:noreply, new_state}
  end
end
