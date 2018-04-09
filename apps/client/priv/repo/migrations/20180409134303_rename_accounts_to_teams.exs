defmodule Client.Repo.Migrations.RenameAccountsToTeams do
  use Ecto.Migration

  def change do
    drop index(:accounts, :name, unique: true)

    rename table("accounts"), to: table("teams")
    rename table("user_accounts"), to: table("user_teams")
    rename table("user_teams"), :account_id, to: :team_id

    create index(:teams, :name, unique: true)
  end
end
