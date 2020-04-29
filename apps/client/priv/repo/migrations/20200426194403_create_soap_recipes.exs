defmodule Client.Repo.Migrations.CreateSoapRecipes do
  use Ecto.Migration

  def change do
    create table(:soap_orders) do
      add(:name, :string, null: false)
      add(:shipping_cost, :integer, null: false)
      timestamps()
    end

    create table(:soap_ingredients) do
      add(:name, :string, null: false)
      add(:cost, :integer, null: false)
      add(:order_id, references(:soap_orders), null: false)
      timestamps()
    end

    create table(:soap_recipes) do
      add(:name, :string, null: false)
      add(:user_id, references(:users), null: false)
      timestamps()
    end

    create(index(:soap_recipes, :user_id))

    create table(:soap_recipe_ingredients) do
      add(:recipe_id, references(:soap_recipes), null: false)
      add(:ingredient_id, references(:soap_ingredients), null: false)
    end
  end
end
