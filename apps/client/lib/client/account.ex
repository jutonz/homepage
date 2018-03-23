defmodule Client.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias Client.Account

  schema "accounts" do
    field(:name, :string)
    timestamps()

    many_to_many :users, Client.User, join_through: "user_accounts", on_delete: :delete_all
  end

  def changeset(%Account{} = account, attrs \\ %{}) do
    account
    |> cast(attrs, ~w(name)a)
    |> validate_required(~w(name)a)
    |> unique_constraint(:name)
  end
end
