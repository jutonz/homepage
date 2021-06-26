defmodule ClientWeb.Soap.IngredientView do
  use ClientWeb, :view

  def total_used(ingredient) do
    ingredient.batch_ingredients
    |> Enum.map(& &1.amount_used)
    |> Enum.sum()
  end
end
