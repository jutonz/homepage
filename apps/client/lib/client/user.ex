defmodule Client.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Client.{Account, Repo, User}

  schema "users" do
    field(:password_hash, :string)
    field(:password, :string, virtual: true)
    field(:email, :string)
    timestamps()

    many_to_many(
      :accounts,
      Account,
      join_through: "user_accounts",
      on_replace: :delete,
      on_delete: :delete_all
    )
  end

  @doc false
  def changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :password, :password_hash])
    |> put_pass_hash()
    |> validate_required([:email, :password_hash])
    |> unique_constraint(:email)
  end

  def get_account(%User{} = user, account_id) do
    query =
      from(
        u in User,
        left_join: a in assoc(u, :accounts),
        where: u.id == ^user.id,
        where: a.id == ^account_id,
        select: a
      )

    account = query |> Repo.one()

    if account do
      {:ok, account}
    else
      {:error, "No account #{account_id} belonging to user #{user.id}"}
    end
  end

  def join_account(%User{} = user, %Account{} = account) do
    with user <- user |> Repo.preload(:accounts),
         cset <- user |> User.changeset(),
         cset <- cset |> Ecto.Changeset.put_assoc(:accounts, [account | user.accounts]),
         {:ok, user} <- cset |> Repo.update(),
         do: {:ok, user},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Could not join account"}
           )
  end

  def leave_account(%User{} = user, %Account{} = account) do
    with user <- user |> Repo.preload(:accounts),
         cset <- user |> User.changeset(),
         new_accounts <- user.accounts |> List.delete(account),
         cset <- cset |> Ecto.Changeset.put_assoc(:accounts, new_accounts),
         {:ok, user} <- cset |> Repo.update(),
         do: {:ok, account},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Could not join account"}
           )
  end

  ##
  # If the virtual key :password is a part of the changeset, add a hash before
  # it is inserted into the DB. Virtual fields are automatically not inserted
  # by ecto, so the password itself will never be stored.
  defp put_pass_hash(changeset) do
    pass = changeset.changes[:password]

    if pass do
      {:ok, hashed} = Auth.hash_password(pass)
      changeset |> Ecto.Changeset.change(%{password: nil, password_hash: hashed})
    else
      changeset
    end
  end
end
