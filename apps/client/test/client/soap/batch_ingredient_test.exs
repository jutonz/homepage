defmodule Client.Soap.BatchIngredientTest do
  use Client.DataCase, async: true

  alias Client.{
    Repo,
    Soap.BatchIngredient,
    Soap.Ingredient
  }

  describe "create/3" do
    test "adds an ingredient to the batch" do
      user = insert(:user)
      batch = insert(:soap_batch, user_id: user.id)
      order = insert(:soap_order, user_id: user.id)
      ingredient = insert(:soap_ingredient, order_id: order.id)
      attrs = %{amount_used: 123}

      {:ok, %Ingredient{}} =
        BatchIngredient.create(
          user.id,
          ingredient.id,
          batch.id,
          attrs
        )

      ingredient_batch_ids =
        Ingredient
        |> Repo.get(ingredient.id)
        |> Repo.preload(:batches)
        |> Map.get(:batches)
        |> Enum.map(& &1.id)

      assert ingredient_batch_ids == [batch.id]
    end

    test "fails if the ingredient belongs to another user's order" do
      user = insert(:user)
      batch = insert(:soap_batch, user_id: user.id)
      other_user = insert(:user)
      other_order = insert(:soap_order, user_id: other_user.id)
      other_ingredient = insert(:soap_ingredient, order_id: other_order.id)
      attrs = %{amount_used: 123}

      result =
        BatchIngredient.create(
          user.id,
          other_ingredient.id,
          batch.id,
          attrs
        )

      assert result == {:error, "No such ingredient"}
    end

    test "fails if the batch belongs to another user" do
      user = insert(:user)
      other_user = insert(:user)
      other_batch = insert(:soap_batch, user_id: other_user.id)
      order = insert(:soap_order, user_id: user.id)
      ingredient = insert(:soap_ingredient, order_id: order.id)
      attrs = %{amount_used: 123}

      result =
        BatchIngredient.create(
          user.id,
          ingredient.id,
          other_batch.id,
          attrs
        )

      assert result == {:error, "No such batch"}
    end
  end
end
