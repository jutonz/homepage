defmodule Client.Repo.Migrations.AddDepletedToSoapIngredients do
  use Ecto.Migration

  def change do
    alter table("soap_ingredients") do
      add(:depleted_at, :utc_datetime)
    end
  end
end
