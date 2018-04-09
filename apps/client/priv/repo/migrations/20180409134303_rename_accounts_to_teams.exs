defmodule Client.Repo.Migrations.RenameAccountsToTeams do
  use Ecto.Migration

  def change do
    rename table("accounts"), to: table("teams")
    rename table("user_accounts"), to: table("user_teams")
    rename table("user_teams"), :account_id, to: :team_id
  end
end
