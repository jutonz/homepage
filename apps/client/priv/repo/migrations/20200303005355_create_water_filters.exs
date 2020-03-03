defmodule Client.Repo.Migrations.CreateWaterFilters do
  use Ecto.Migration

  def change do
    create(table("water_log_filters", primary_key: false)) do
      add(:id, :uuid, primary_key: true)
      add(:water_log_id, :uuid, null: false)
      timestamps()
    end
  end
end
