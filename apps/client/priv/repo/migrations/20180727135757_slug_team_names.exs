defmodule Client.Repo.Migrations.SlugTeamNames do
  use Ecto.Migration

  def up do
    Client.Team
    |> Client.Repo.all()
    |> Enum.each(fn team ->
      team
      |> Client.Team.changeset(%{name: team.name})
      |> Client.Repo.update!
    end)
  end

  def down, do: nil
end
