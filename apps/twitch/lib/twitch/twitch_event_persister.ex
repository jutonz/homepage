defmodule Twitch.TwitchEventPersister do
  use GenStage

  @persist_after 10

  def start_link(arg) do
    GenStage.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    # {:consumer, state, subscribe_to: []}
    state = []
    {:consumer, state, subscribe_to: [Twitch.TwitchProducer]}
  end

  # Receive events from Producer
  # Trigger application logic
  def handle_events(events, _from, state) do
    new_state =
      events
      |> Enum.map(&Map.from_struct(&1))
      |> Enum.map(fn ev ->
        %Twitch.TwitchEvent{} |> Twitch.TwitchEvent.changeset(ev)
      end)
      |> Enum.concat(state)
      |> (fn st ->
            if length(st) >= @persist_after do
              st |> Enum.each(&Twitch.Repo.insert(&1))
              []
            else
              st
            end
          end).()

    # Consumers do not emit events
    {:noreply, [], new_state}
  end
end
