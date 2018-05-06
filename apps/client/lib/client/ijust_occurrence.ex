defmodule Client.IjustOccurrence do
  use Ecto.Schema
  import Ecto.Changeset
  alias Client.{User, Repo, IjustEvent, IjustOccurrence}

  schema "ijust_occurrences" do
    timestamps()

    belongs_to(:user, User)
    belongs_to(:ijust_event, IjustEvent)
  end

  def changeset(%IjustOccurrence{} = occurrence, attrs \\ %{}) do
    # No attrs to track, but provide this function for parity
    occurrence |> cast(attrs, [])
  end

  def get_for_event(event_id) do
    occurrences = IJustOccurrence |> Repo.get_by(ijust_event_id: event_id)

    {:ok, occurrences}
  end
end
