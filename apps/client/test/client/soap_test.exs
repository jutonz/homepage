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
  end
end
