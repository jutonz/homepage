defmodule Client.Repo.Migrations.CreateStorageItems do
  use Ecto.Migration

  def change do
    create table(:storage_items) do
      add(:context_id, references(:storage_contexts), null: false)
      add(:name, :string, null: false)
      add(:description, :string)
      add(:location, :string, null: false)
      add(:unpacked_at, :utc_datetime)
      timestamps(type: :utc_datetime, null: false)
    end

    create(index(:storage_items, [:context_id, :name], unique: true))
  end
end
