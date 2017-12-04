defmodule Client.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Client.User

  schema "users" do
    field :password_hash, :string
    field :password, :string, virtual: true
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
      |> cast(attrs, [:email, :password, :password_hash])
      |> put_pass_hash()
      |> validate_required([:email, :password_hash])
      |> unique_constraint(:email)
  end

  ##
  # If the virtual key :password is a part of the changeset, add a hash before
  # it is inserted into the DB. Virtual fields are automatically not inserted
  # by ecto, so the password itself will never be stored.
  defp put_pass_hash(changeset) do
    pass = changeset.changes.password
    if pass do
      {:ok, hashed} = Client.AuthServer.hash_password(pass)
      changeset |> change(%{ password: nil, password_hash: hashed })
    else
      changeset
    end
  end
end
