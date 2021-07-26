defmodule Client.Repo.Migrations.CreateStorageContexts do
  use Ecto.Migration

  def change do
    create table(:storage_contexts) do
      add(:creator_id, references(:users), null: false)
      add(:name, :string, null: false)
      timestamps(type: :utc_datetime, null: false)
    end

    create(index(:storage_contexts, [:creator_id, :name], unique: true))

    create table(:storage_context_teams) do
      add(:context_id, references(:storage_contexts))
      add(:team_id, references(:teams))
    end

    create(index(:storage_context_teams, [:team_id, :context_id], unique: true))
  end
end
