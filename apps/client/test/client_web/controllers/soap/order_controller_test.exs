defmodule ClientWeb.Soap.OrderControllerTest do
  use ClientWeb.ConnCase, async: true
  alias Client.Factory

  describe "show/2" do
    test "says if an ingredient is depleted", %{conn: conn} do
      user = Factory.insert(:user)
      order = Factory.insert(:soap_order, user_id: user.id)

      depleted_ingredient =
        Factory.insert(:soap_ingredient, order_id: order.id, depleted_at: DateTime.utc_now())

      undepleted_ingredient = Factory.insert(:soap_ingredient, order_id: order.id)

      html =
        conn
        |> get(Routes.soap_order_path(conn, :show, order), as: user.id)
        |> html_response(200)
        |> Floki.parse_document!()

      [depleted_ele] =
        Floki.find(
          html,
          "[data-ingredient-id='#{depleted_ingredient.id}'] [data-role=ingredient-depleted]"
        )

      assert Floki.text(depleted_ele) =~ "✓"

      [undepleted_ele] =
        Floki.find(
          html,
          "[data-ingredient-id='#{undepleted_ingredient.id}'] [data-role=ingredient-depleted]"
        )

      refute Floki.text(undepleted_ele) =~ "✓"
    end
  end
end
