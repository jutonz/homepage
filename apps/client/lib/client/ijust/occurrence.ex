defmodule Client.Ijust.Occurrence do
  use Ecto.Schema
  import Ecto.Changeset
  alias Client.{User, Ijust}

  schema "ijust_occurrences" do
    timestamps()
    belongs_to(:user, User)
  end

  def changeset(%Ijust.Occurrence{} = occurrence) do
    # No attrs to track, but provide this function for parity
    occurrence |> cast(%{}, [])
  end
end
