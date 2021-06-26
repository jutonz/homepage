defmodule Client.SoapTest do
  use Client.DataCase, async: true
  alias Client.Soap

  describe "get_order_ingredient/3" do
    test "gets an ingredient from the order" do
      user = insert(:user)
      order = insert(:soap_order, user_id: user.id)
      ingredient = insert(:soap_ingredient, order_id: order.id)

      actual = Soap.get_order_ingredient(user.id, order.id, ingredient.id)

      assert actual.id == ingredient.id
    end

    test "is nil if the order belongs to another user" do
      user = insert(:user)
      other_user = insert(:user)
      order = insert(:soap_order, user_id: other_user.id)
      ingredient = insert(:soap_ingredient, order_id: order.id)

      actual = Soap.get_order_ingredient(user.id, order.id, ingredient.id)

      assert is_nil(actual)
    end

    test "is nil if the ingredient belongs to another order" do
      user = insert(:user)
      order = insert(:soap_order, user_id: user.id)
      other_order = insert(:soap_order, user_id: user.id)
      ingredient = insert(:soap_ingredient, order_id: other_order.id)

      actual = Soap.get_order_ingredient(user.id, order.id, ingredient.id)

      assert is_nil(actual)
    end
  end

  describe "list_ingredients/1" do
    test "lists a user's ingredients" do
      me = insert(:user)
      my_order = insert(:soap_order, user_id: me.id)
      my_ingredient = insert(:soap_ingredient, order_id: my_order.id)

      actual = Soap.list_ingredients(me.id)

      assert actual == [my_ingredient]
    end

    test "doesn't list someone else's ingredients" do
      me = insert(:user)
      another_user = insert(:user)
      another_order = insert(:soap_order, user_id: another_user.id)
      _another_ingredient = insert(:soap_ingredient, order_id: another_order.id)

      actual = Soap.list_ingredients(me.id)

      assert actual == []
    end

    test "orders ingredients by ID" do
      me = insert(:user)
      order = insert(:soap_order, user_id: me.id)
      ingredient1 = insert(:soap_ingredient, order_id: order.id)
      ingredient2 = insert(:soap_ingredient, order_id: order.id)

      actual = me.id |> Soap.list_ingredients() |> Enum.map(& &1.id)

      assert actual == [ingredient1.id, ingredient2.id]
    end
  end

  describe "delete_batch_ingredient/1" do
    test "deletes a batch ingredient" do
      user = insert(:user)
      batch = insert(:soap_batch, user_id: user.id)
      order = insert(:soap_order, user_id: user.id)
      ingredient = insert(:soap_ingredient, order_id: order.id)

      ba =
        insert(:soap_batch_ingredient,
          batch_id: batch.id,
          ingredient_id: ingredient.id
        )

      response = Soap.delete_batch_ingredient(user.id, batch.id, ba.id)

      assert {:ok, ba} = response
    end
  end

  describe "get_batch_with_ingredients/2" do
    test "it orders ingredients by ID" do
      user = insert(:user)
      batch = insert(:soap_batch, user_id: user.id)
      order = insert(:soap_order, user_id: user.id)

      sbi1 =
        insert(:soap_batch_ingredient,
          ingredient_id: insert(:soap_ingredient, order_id: order.id).id,
          batch_id: batch.id
        )

      sbi2 =
        insert(:soap_batch_ingredient,
          ingredient_id: insert(:soap_ingredient, order_id: order.id).id,
          batch_id: batch.id
        )

      actual =
        user.id
        |> Soap.get_batch_with_ingredients(batch.id)
        |> Map.get(:batch_ingredients)
        |> Enum.map(& &1.ingredient_id)

      assert actual == [sbi1.ingredient_id, sbi2.ingredient_id]
    end
  end

  describe "get_order_with_ingredients/2" do
    test "returns an order with ingredients" do
      user = insert(:user)
      order = insert(:soap_order, user_id: user.id)
      ingredient = insert(:soap_ingredient, order_id: order.id)

      actual = Soap.get_order_with_ingredients(user.id, order.id)

      assert actual.id == order.id
      assert Enum.map(actual.ingredients, & &1.id) == [ingredient.id]
    end

    test "doesn't return another user's order" do
      user = insert(:user)
      not_my_order = insert(:soap_order, user_id: insert(:user).id)

      refute Soap.get_order_with_ingredients(user.id, not_my_order.id)
    end

    test "includes only ingredients for this order" do
      user = insert(:user)
      order = insert(:soap_order, user_id: user.id)
      ingredient = insert(:soap_ingredient, order_id: order.id)
      other_order = insert(:soap_order, user_id: user.id)
      _other_ingredient = insert(:soap_ingredient, order_id: other_order.id)

      actual = Soap.get_order_with_ingredients(user.id, order.id)

      assert actual.id == order.id
      assert Enum.map(actual.ingredients, & &1.id) == [ingredient.id]
    end

    test "orders ingredients by ID" do
      user = insert(:user)
      order = insert(:soap_order, user_id: user.id)
      ingredient1 = insert(:soap_ingredient, order_id: order.id)
      ingredient2 = insert(:soap_ingredient, order_id: order.id)

      actual = Soap.get_order_with_ingredients(user.id, order.id)

      ingredient_ids = Enum.map(actual.ingredients, & &1.id)
      assert ingredient_ids == [ingredient1.id, ingredient2.id]
    end
  end
end
