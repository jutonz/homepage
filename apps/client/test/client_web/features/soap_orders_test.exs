defmodule ClientWeb.SoapOrdersFeatureTests do
  use ClientWeb.FeatureCase

  test "can create a order", %{session: session} do
    user = insert(:user)

    session
    |> visit(soap_order_path(@endpoint, :index, as: user.id))
    |> click(role("create-soap-order"))
    |> fill_in(role("soap-order-name-input"), with: "fff")
    |> fill_in(role("soap-order-shipping-cost-input"), with: "1000")
    |> click(role("soap-order-submit"))
    |> find(role("soap-order-name", text: "fff"))

    session
    |> visit(soap_order_path(@endpoint, :index))
    |> find(role("soap-order-name", text: "fff"))
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
end
