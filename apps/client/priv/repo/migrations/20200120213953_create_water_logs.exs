defmodule Client.Repo.Migrations.CreateWaterLogs do
  use Ecto.Migration

  def change do
    create table(:water_logs, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:user_id, :integer, null: false)
      add(:name, :string, null: false)
      timestamps()
    end

    create(index(:water_logs, [:user_id, :name], unique: true))

    create table(:water_log_entries, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:water_log_id, :uuid, null: false)
      add(:user_id, :integer, null: false)
      add(:ml, :integer, null: false)
      timestamps()
    end
  end
end
