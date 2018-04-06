defmodule Client.Ijust.Occurrence do
  use Ecto.Schema
  import Ecto.Changeset
  alias Client.{User,Ijust}

  schema "ijust_occurrences" do
    timestamps()
    belongs_to :user, User
  end

  def changeset(%Ijust.Occurrence{} = occurrence, attrs \\ %{}) do
    occurrence
    |> cast(attrs, [:name, :count])
    |> validate_required(:name, :count)
    |> unique_constraint(:name)
  end
end
