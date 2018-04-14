defmodule Client.IjustOccurrence do
  use Ecto.Schema
  import Ecto.Changeset
  alias Client.{User, IjustEvnet, IjustOccurrence}

  schema "ijust_occurrences" do
    timestamps()

    belongs_to(:user, User)
    belongs_to(:ijust_event, IjustEvent)
  end

  def changeset(%IjustOccurrence{} = occurrence, attrs \\ %{}) do
    # No attrs to track, but provide this function for parity
    occurrence |> cast(attrs, [])
  end
end
