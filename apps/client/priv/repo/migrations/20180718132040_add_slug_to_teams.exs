defmodule Client.Repo.Migrations.AddSlugToTeams do
  use Ecto.Migration

  def up do
    alter table("teams") do
      add(:slug, :string)
    end

    rename(table("user_teams"), :team_id, :team_slug)
    create(index(:teams, :slug, unique: true))
  end

  def down do
    alter table("teams") do
      remove(:slug)
    end
  end
end
