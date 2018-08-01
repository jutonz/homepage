defmodule Client.Team do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Client.{Team, Repo, User, TeamSlugger}

  @type t :: %Team{}

  schema "teams" do
    field(:name, :string)
    field(:slug, :string)
    timestamps()

    many_to_many(
      :users,
      Client.User,
      join_through: "user_teams",
      join_keys: [user_id: :id, team_id: :id],
      on_replace: :delete,
      on_delete: :delete_all
    )
  end

  def changeset(%Team{} = team, attrs \\ %{}) do
    team
    |> cast(attrs, ~w(name slug)a)
    |> TeamSlugger.maybe_add_slug()
    |> validate_required(~w(name slug)a)
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
  end

  def get_team_user(team_id, user_id) do
    query =
      from(
        user in User,
        left_join: team in assoc(user, :teams),
        select: user,
        where: user.id == ^user_id,
        where: team.id == ^team_id
      )

    case query |> Repo.one() do
      user = %User{} -> {:ok, user}
      _ -> {:error, "Could not find matching team"}
    end
  end

  def get_by_name(name) do
    case Team |> Repo.get_by(name: name) do
      team = %Team{} -> {:ok, team}
      _ -> {:error, "An team called #{name} does not exist."}
    end
  end

  @spec get_by_slug(String.t()) :: {:ok, Team.t()} | {:error, String.t()}
  def get_by_slug(slug) do
    case Team |> Repo.get_by(slug: slug) do
      team = %Team{} -> {:ok, team}
      _ -> {:error, "An team with slug #{slug} does not exist."}
    end
  end
end
