defmodule ClientWeb.SoapOrdersFeatureTests do
  use ClientWeb.FeatureCase

  test "can create a order", %{session: session} do
    user = insert(:user)

    session
    |> visit(soap_order_path(@endpoint, :index, as: user.id))
    |> click(role("create-soap-order"))
    |> fill_in(role("soap-order-name-input"), with: "fff")
    |> fill_in(role("soap-order-shipping-cost-input"), with: "15.00")
    |> fill_in(role("soap-order-tax-input"), with: "3")
    |> click(role("soap-order-submit"))
    |> assert_has(role("soap-order-name", text: "fff"))
    |> assert_has(role("order-ingredients-cost", text: "$0.00"))
    |> assert_has(role("order-shipping-cost", text: "$15.00"))
    |> assert_has(role("order-tax", text: "$3.00"))
    |> assert_has(role("order-total-cost", text: "$18.00"))

    session
    |> visit(soap_order_path(@endpoint, :index))
    |> assert_has(role("soap-order-name", text: "fff"))
  end

  test "can edit a order", %{session: session} do
    user = insert(:user)
    order = insert(:soap_order, user_id: user.id)

    session
    |> visit(soap_order_path(@endpoint, :edit, order.id, as: user.id))
    |> fill_in(role("soap-order-name-input"), with: "fff")
    |> click(role("soap-order-submit"))
    |> find(role("soap-order-name", text: "fff"))

    session
    |> visit(soap_order_path(@endpoint, :index))
    |> find(role("soap-order-name", text: "fff"))
  end

  test "can delete a order", %{session: session} do
    user = insert(:user)
    order = insert(:soap_order, user_id: user.id)

    session
    |> visit(soap_order_path(@endpoint, :show, order.id, as: user.id))
    |> accept_confirm(fn session ->
      click(session, role("soap-order-delete"))
    end)

    refute_has(session, role("soap-order-name", text: order.name))
    assert current_path(session) == soap_order_path(@endpoint, :index)
  end

  test "can add an ingredient", %{session: session} do
    user = insert(:user)
    order = insert(:soap_order, user_id: user.id)

    session
    |> visit(soap_order_path(@endpoint, :show, order.id, as: user.id))
    |> click(role("order-add-ingredient"))
    |> fill_in(role("soap-order-ingredient-name-input"), with: "HEC")
    |> fill_in(role("soap-order-ingredient-cost-input"), with: "10.00")
    |> fill_in(role("soap-order-ingredient-quantity-input"), with: "452")
    |> click(role("soap-order-ingredient-submit"))
    |> assert_has(role("ingredient-name", text: "HEC"))
    |> assert_has(role("ingredient-cost", text: "$10.00"))
  end

  test "can edit an ingredient", %{session: session} do
    user = insert(:user)
    order = insert(:soap_order, user_id: user.id)
    insert(:soap_ingredient, order_id: order.id, name: "wee", material_cost: Money.new(100))

    session
    |> visit(soap_order_path(@endpoint, :show, order.id, as: user.id))
    |> click(role("ingredient-name", text: "wee"))
    |> fill_in(role("soap-order-ingredient-name-input"), with: "wee2")
    |> fill_in(role("soap-order-ingredient-cost-input"), with: "2")
    |> click(role("soap-order-ingredient-submit"))
    |> assert_has(role("ingredient-name", text: "wee2"))
    |> assert_has(role("ingredient-cost", text: "$2.00"))
  end
end
