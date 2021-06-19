defmodule ClientWeb.Soap.OrderIngredientControllerTest do
  use ClientWeb.ConnCase, async: true
  alias Client.{Factory, Soap}

  describe "update/2" do
    test "allows marking an ingredient as depleted", %{conn: conn} do
      user = Factory.insert(:user)
      order = Factory.insert(:soap_order, user_id: user.id)
      ingredient = Factory.insert(:soap_ingredient, order_id: order.id)
      path = Routes.soap_order_ingredient_path(conn, :update, order, ingredient)

      params = %{
        as: user.id,
        ingredient: %{"depleted_at" => "true"}
      }

      conn
      |> patch(path, params)
      |> html_response(302)

      ingredient = Soap.get_order_ingredient(user.id, order.id, ingredient.id)
      assert ingredient.depleted_at
    end

    test "allows un-marking an ingredient as depleted", %{conn: conn} do
      user = Factory.insert(:user)
      order = Factory.insert(:soap_order, user_id: user.id)

      ingredient =
        Factory.insert(:soap_ingredient, order_id: order.id, depleted_at: DateTime.utc_now())

      path = Routes.soap_order_ingredient_path(conn, :update, order, ingredient)

      params = %{
        as: user.id,
        ingredient: %{"depleted_at" => "false"}
      }

      conn
      |> patch(path, params)
      |> html_response(302)

      ingredient = Soap.get_order_ingredient(user.id, order.id, ingredient.id)
      refute ingredient.depleted_at
    end
  end
end
