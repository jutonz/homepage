defmodule Client.Repo.Migrations.CreateSoapRecipes do
  use Ecto.Migration

  def change do
    create table(:soap_orders) do
      add(:name, :string, null: false)
      add(:shipping_cost, :integer, null: false)
      add(:tax, :integer, null: false)
      add(:user_id, references(:users), null: false)
      timestamps()
    end

    create(index(:soap_orders, :user_id))

    create table(:soap_ingredients) do
      add(:name, :string, null: false)
      add(:material_cost, :integer, null: false)
      add(:overhead_cost, :integer, null: false)
      add(:total_cost, :integer, null: false)
      add(:quantity, :integer, null: false)
      add(:order_id, references(:soap_orders), null: false)
      timestamps()
    end

    create table(:soap_batches) do
      add(:name, :string, null: false)
      add(:user_id, references(:users), null: false)
      timestamps()
    end

    create(index(:soap_batches, :user_id))

    create table(:soap_batch_ingredients, primary_key: false) do
      add(:batch_id, references(:soap_batches), null: false)
      add(:ingredient_id, references(:soap_ingredients), null: false)
      add(:amount_used, :integer, null: false)
    end
  end
end
