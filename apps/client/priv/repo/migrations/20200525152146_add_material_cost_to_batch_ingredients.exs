defmodule Client.Repo.Migrations.AddMaterialCostToBatchIngredients do
  use Ecto.Migration
  alias Client.Repo
  alias Client.Soap.BatchIngredient

  def up do
    alter table("soap_batch_ingredients") do
      add(:id, :bigserial, primary_key: true)
      add(:material_cost, :integer, null: true)
    end

    flush()

    migrate_existing_batch_ingredients()

    flush()

    alter table("soap_batch_ingredients") do
      modify(:material_cost, :integer, null: false)
    end
  end

  def down do
    alter table("soap_batch_ingredients") do
      remove(:id)
      remove(:material_cost)
    end
  end

  defp migrate_existing_batch_ingredients do
    BatchIngredient
    |> Repo.all()
    |> Repo.preload(:ingredient)
    |> Enum.each(fn bi ->
      attrs = %{
        material_cost:
          BatchIngredient.material_cost(
            bi.ingredient.quantity,
            bi.ingredient.material_cost,
            bi.amount_used
          )
      }

      bi
      |> Ecto.Changeset.change(attrs)
      |> Repo.update!()
    end)
  end
end
