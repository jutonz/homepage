defmodule Client.Team do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Client.{Team, Repo, User}

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
    |> maybe_add_slug()
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

  def maybe_add_slug(changeset) do
    # re-slug if there is 1) no existing slug, or 2) the name has changed
    no_slug = !changeset.data.slug
    name_changed = changeset.changes |> Map.has_key?(:name)

    if no_slug || name_changed do
      name = if name_changed, do: changeset.changes.name, else: changeset.data.name
      slug = find_a_slug(name)
      changeset |> Ecto.Changeset.change(%{slug: slug})
    else
      changeset
    end
  end

  def generate_slug(name, index) when is_number(index) do
    slug = name |> Client.Slug.generate

    if index > 0 do
      "#{slug}-#{to_string(index)}"
    else
      slug
    end
  end

  def find_a_slug(name, slug_guess \\ nil, tries \\ 0) do
    IO.puts "hi: #{name} #{slug_guess} #{tries}"
    slug_guess = slug_guess || generate_slug(name, tries)

    case Team |> Repo.get_by(slug: slug_guess) do
      nil -> slug_guess
      _ -> find_a_slug(name, slug_guess, tries + 1)
    end
  end
end
