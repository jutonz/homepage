defmodule Client.Repo.Migrations.AddCostToIjustEvents do
  use Ecto.Migration

  def change do
    alter(table("ijust_events")) do
      add(:cost, :integer)
    end
  end
end
