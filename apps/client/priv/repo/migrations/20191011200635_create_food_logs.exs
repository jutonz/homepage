defmodule Client.Repo.Migrations.CreateFoodLogs do
  use Ecto.Migration

  def change do
    create table(:food_logs, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:description, :string)
      add(:owner_id, :bigint, null: false)
      timestamps()
    end

    create table(:food_log_days, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:user_id, :bigint, null: false)
      add(:day, :naive_datetime, null: false)
      add(:food_log_id, :uuid, null: false)
      timestamps()
    end

    create table(:food_log_entries, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:description, :string, null: false)
      add(:food_log_day_id, :uuid, null: false)
      timestamps()
    end

    create(index(:food_logs, :owner_id))
    create(index(:food_log_days, :food_log_id))
    create(index(:food_log_entries, :food_log_day_id))
    create(index(:food_logs, [:owner_id, :name], unique: true))
  end
end
