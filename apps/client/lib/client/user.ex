defmodule Client.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Client.{Team, Repo, User}

  @type t :: %__MODULE__{}

  @derive {Jason.Encoder, only: ~w[id email]a}

  schema "users" do
    field(:password_hash, :string)
    field(:password, :string, virtual: true)
    field(:email, :string)
    timestamps()

    many_to_many(
      :teams,
      Team,
      join_through: "user_teams",
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

  def get_by_email(email) do
    case User |> Repo.get_by(email: email) do
      user = %User{} -> {:ok, user}
      _ -> {:error, "No user with email #{email}"}
    end
  end

  def change_password(user, current_pw, new_pw) do
    with {:ok, _pass} <- Auth.check_password(current_pw, user.password_hash),
         changeset <- User.changeset(user, %{password: new_pw}),
         {:ok, user} <- Repo.update(changeset),
         do: {:ok, user},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Could not change password"}
           )
  end

  def get_team(%User{} = user, team_id) do
    query =
      from(
        u in User,
        left_join: a in assoc(u, :teams),
        where: u.id == ^user.id,
        where: a.id == ^team_id,
        select: a
      )

    team = query |> Repo.one()

    if team do
      {:ok, team}
    else
      {:error, "No team #{team_id} belonging to user #{user.id}"}
    end
  end

  def join_team(%User{} = user, %Team{} = team) do
    with user <- user |> Repo.preload(:teams),
         cset <- user |> User.changeset(),
         cset <- cset |> Ecto.Changeset.put_assoc(:teams, [team | user.teams]),
         {:ok, user} <- cset |> Repo.update(),
         do: {:ok, user},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Could not join team"}
           )
  end

  def leave_team(%User{} = user, %Team{} = team) do
    with user <- user |> Repo.preload(:teams),
         cset <- user |> User.changeset(),
         new_teams <- user.teams |> List.delete(team),
         cset <- cset |> Ecto.Changeset.put_assoc(:teams, new_teams),
         {:ok, _user} <- cset |> Repo.update(),
         do: {:ok, team},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Could not join team"}
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
