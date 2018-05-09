defmodule Client.IjustOccurrence do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Client.{User, Repo, IjustEvent, IjustOccurrence}

  @type t :: %__MODULE__{}
  @moduledoc false

  schema "ijust_occurrences" do
    timestamps()

    belongs_to(:user, User)
    belongs_to(:ijust_event, IjustEvent)
  end

  def changeset(%IjustOccurrence{} = occurrence, attrs \\ %{}) do
    # No attrs to track, but provide this function for parity
    occurrence |> cast(attrs, [])
  end

  @spec get_for_event(String.t()) :: {:ok, list(IjustOccurrence.t())}
  def get_for_event(event_id) do
    query =
      from(
        occ in IjustOccurrence,
        where: occ.ijust_event_id == ^event_id,
        order_by: [desc: occ.inserted_at],
        limit: 100
      )

    {:ok, query |> Repo.all()}
  end
end
