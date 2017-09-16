defmodule Homepage.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homepage.User

  schema "users" do
    field :password, :string
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end
end
