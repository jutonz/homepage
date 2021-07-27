defmodule Client.Repo.Migrations.CreateStorageBoxes do
  use Ecto.Migration

  def change do
    create table(:storage_boxes) do
      add(:context_id, references(:storage_contexts), null: false)
      add(:name, :string, null: false)
      add(:location, :string, null: false)
      add(:unpacked_at, :utc_datetime)
      timestamps(type: :utc_datetime, null: false)
    end

    create(index(:storage_boxes, [:context_id, :name], unique: true))
  end
end
