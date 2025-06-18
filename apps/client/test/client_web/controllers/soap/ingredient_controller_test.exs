defmodule ClientWeb.Soap.IngredientControllerTest do
  use ClientWeb.ConnCase, async: true
  alias Client.Factory

  describe "index" do
    test "includes all of my ingredients", %{conn: conn} do
      user = Factory.insert(:user)
      order = Factory.insert(:soap_order, user_id: user.id)
      ingredient = Factory.insert(:soap_ingredient, order_id: order.id)

      conn
      |> get(Routes.soap_ingredient_path(conn, :index), as: user.id)
      |> parsed_html_response(200)
      |> assert_contains_selector("[data-role=soap-ingredient-#{ingredient.id}]")
    end

    test "includes details of an ingredient", %{conn: conn} do
      user = Factory.insert(:user)
      order = Factory.insert(:soap_order, user_id: user.id)
      ingredient = Factory.insert(:soap_ingredient, order_id: order.id)

      html =
        conn
        |> get(Routes.soap_ingredient_path(conn, :index), as: user.id)
        |> html_response(200)

      assert html =~ ingredient.name
      assert html =~ to_string(ingredient.id)
      assert html =~ Money.to_string(ingredient.material_cost)
      assert html =~ Money.to_string(ingredient.overhead_cost)
      assert html =~ Money.to_string(ingredient.total_cost)
      assert html =~ to_string(ingredient.quantity)
    end

    test "includes a link to the ingredient's order", %{conn: conn} do
      user = Factory.insert(:user)
      order = Factory.insert(:soap_order, user_id: user.id)
      Factory.insert(:soap_ingredient, order_id: order.id)

      html =
        conn
        |> get(Routes.soap_ingredient_path(conn, :index), as: user.id)
        |> html_response(200)
        |> Floki.parse_document!()

      selector = "a[href='#{Routes.soap_order_path(conn, :show, order)}']"
      assert [_ele] = Floki.find(html, selector)
    end
  end

  describe "show" do
    test "shows info about an ingredient", %{conn: conn} do
      user = insert(:user)
      order = insert(:soap_order, user_id: user.id)
      ingredient = insert(:soap_ingredient, order_id: order.id)
      path = Routes.soap_ingredient_path(conn, :show, ingredient)

      html =
        conn
        |> get(path, as: user.id)
        |> html_response(200)

      assert html =~ ingredient.name
    end

    test "includes a link to the order", %{conn: conn} do
      user = insert(:user)
      order = insert(:soap_order, user_id: user.id)
      ingredient = insert(:soap_ingredient, order_id: order.id)
      path = Routes.soap_ingredient_path(conn, :show, ingredient)

      conn
      |> get(path, as: user.id)
      |> parsed_html_response(200)
      |> assert_contains_selector("a[href='#{Routes.soap_order_path(conn, :show, order)}']")
    end

    test "says which batches the ingredient was used in", %{conn: conn} do
      user = insert(:user)
      order = insert(:soap_order, user_id: user.id)
      ingredient = insert(:soap_ingredient, order_id: order.id)
      batch = insert(:soap_batch, user_id: user.id)

      insert(:soap_batch_ingredient,
        batch_id: batch.id,
        ingredient_id: ingredient.id,
        amount_used: 20
      )

      path = Routes.soap_ingredient_path(conn, :show, ingredient)

      html =
        conn
        |> get(path, as: user.id)
        |> html_response(200)

      assert html =~ batch.name
      assert html =~ "20g"

      assert_contains_selector(
        Floki.parse_document!(html),
        "a[href='#{Routes.soap_batch_path(conn, :show, batch)}']"
      )
    end
  end
end
