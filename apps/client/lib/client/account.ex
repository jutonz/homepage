defmodule Client.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Client.{Account, Repo, User}

  schema "accounts" do
    field(:name, :string)
    timestamps()

    many_to_many(:users, Client.User, join_through: "user_accounts", on_delete: :delete_all)
  end

  def changeset(%Account{} = account, attrs \\ %{}) do
    account
    |> cast(attrs, ~w(name)a)
    |> validate_required(~w(name)a)
    |> unique_constraint(:name)
  end

  def get_account_user(account_id, user_id) do
    query =
      from(
        user in User,
        left_join: account in assoc(user, :accounts),
        select: user,
        where: user.id == ^user_id,
        where: account.id == ^account_id
      )

    case query |> Repo.one() do
      user = %User{} -> {:ok, user}
      _ -> {:error, "Could not find matching account"}
    end
  end
end
