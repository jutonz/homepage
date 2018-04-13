defmodule Client.Ijust.Occurrence do
  use Ecto.Schema
  import Ecto.Changeset
  alias Client.{User, Ijust}

  schema "ijust_occurrences" do
    timestamps()

    belongs_to(:user, User)
    belongs_to(:ijust_event, Ijust.Event)
  end

  def changeset(%Ijust.Occurrence{} = occurrence, attrs \\ %{}) do
    # No attrs to track, but provide this function for parity
    occurrence |> cast(attrs, [])
  end
end
