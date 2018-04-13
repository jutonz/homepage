defmodule Client.Repo.Migrations.AddIjust do
  use Ecto.Migration

  def change do
    create table("ijust_contexts") do
      add(:name, :string)
      add(:user_id, references(:users))
      timestamps()
    end

    create table("ijust_events") do
      add(:name, :string)
      add(:count, :integer, default: 0)
      add(:ijust_context_id, references(:ijust_contexts))
      timestamps()
    end

    create table("ijust_occurrences") do
      add(:ijust_event_id, references(:ijust_events))
      add(:user_id, references(:users))
      timestamps()
    end

    create(index(:ijust_contexts, [:user_id, :name], unique: true))
    create(index(:ijust_events, [:ijust_context_id, :name], unique: true))
  end
end
