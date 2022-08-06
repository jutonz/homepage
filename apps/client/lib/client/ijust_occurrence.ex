defmodule Client.IjustOccurrence do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Client.{User, Repo, IjustOccurrence, IjustEvent}

  @type t :: %__MODULE__{}
  @moduledoc false

  schema "ijust_occurrences" do
    timestamps()
    belongs_to(:user, User)
    belongs_to(:ijust_event, IjustEvent)
  end

  def changeset(%IjustOccurrence{} = occurrence, attrs \\ %{}) do
    occurrence
    |> cast(attrs, [:ijust_event_id])
    |> validate_required([:ijust_event_id])
    |> foreign_key_constraint(:ijust_event_id)
  end

  @spec get_for_event(integer, integer) :: {:ok, list(IjustOccurrence.t())}
  def get_for_event(event_id, offset) do
    query =
      from(
        occ in IjustOccurrence,
        where: occ.ijust_event_id == ^event_id,
        order_by: [desc: occ.inserted_at],
        offset: ^offset
      )

    {:ok, query |> Repo.all()}
  end

  def delete_by_user(_user_id, occurrence_id) do
    occurrence = IjustOccurrence |> Repo.get!(occurrence_id)

    case occurrence |> Repo.delete() do
      {:ok, occ} -> {:ok, occ}
      {:error, _changeset} -> {:error, "Failed to delete occurrence"}
    end
  end
end
