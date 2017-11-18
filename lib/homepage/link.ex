defmodule Homepage.Link do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homepage.Link

  schema "links" do
    field :description, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(%Link{} = user, attrs) do
    user
      |> cast(attrs, [:url, :description])
  end
end
