defmodule ClientWeb.Soap.IngredientViewTest do
  use ClientWeb.ConnCase, async: true
  alias Client.{Repo, Soap}
  alias ClientWeb.Soap.IngredientView

  describe "total_used/1" do
    test "sums the amount used in each batch" do
      user = insert(:user)
      order = insert(:soap_order, user_id: user.id)
      ingredient = insert(:soap_ingredient, order_id: order.id)
      batch = insert(:soap_batch, user_id: user.id)

      insert_list(2, :soap_batch_ingredient,
        batch_id: batch.id,
        ingredient_id: ingredient.id,
        amount_used: 10
      )

      ingredient =
        user.id
        |> Soap.get_ingredient(ingredient.id)
        |> Repo.preload(:batch_ingredients)

      assert IngredientView.total_used(ingredient) == 20
    end
  end
end
