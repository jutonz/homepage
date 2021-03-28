defmodule Client.Repo.Migrations.CreateTrainLogs do
  use Ecto.Migration

  def change do
    create table(:train_logs) do
      add(:user_id, references("users"), null: false)
      add(:location, :string, null: false)
      timestamps(type: :utc_datetime)
    end

    create(index(:train_logs, [:user_id, :location], unique: true))

    create table(:train_sightings) do
      add(:log_id, references("train_logs"), null: false)
      add(:sighted_at, :utc_datetime, null: false)
      add(:direction, :string, null: false)
      add(:cars, :integer, null: false)
      timestamps(type: :utc_datetime)
    end

    create table(:train_engines) do
      add(:user_id, references("users"), null: false)
      add(:number, :integer, null: false)
      timestamps(type: :utc_datetime)
    end

    create(index(:train_engines, [:number], unique: true))

    create table(:train_engine_sightings) do
      add(:engine_id, references("train_engines"), null: false)
      add(:sighting_id, references("train_sightings"), null: false)
      timestamps(type: :utc_datetime)
    end
  end
end
