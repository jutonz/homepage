defmodule Client.Repo.Migrations.AddSlugToTeams do
  use Ecto.Migration

  def change do
    alter table("teams") do
      add(:slug, :string)
    end

    create(index(:teams, :slug, unique: true))

    # Ensure all db chagnes are complete
    flush()

    # Re-insert all teams to trigger auto-slugging logic
    Client.Team
    |> Client.Repo.all()
    |> Enum.each(fn team ->
      team
      |> Client.Team.changeset(%{name: team.name})
      |> Client.Repo.update!()
    end)
  end

  def down do
    alter table("teams") do
      remove(:slug)
    end
  end
end
