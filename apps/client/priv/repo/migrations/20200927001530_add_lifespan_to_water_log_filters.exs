defmodule Client.Repo.Migrations.AddLifespanToWaterLogFilters do
  use Ecto.Migration

  def change do
    alter table(:water_log_filters) do
      add(:lifespan, :integer)
    end
  end
end
