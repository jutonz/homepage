defmodule ClientWeb.SoapBatchesFeatureTests do
  use ClientWeb.FeatureCase
  alias Client.Soap

  test "can create a batch", %{session: session} do
    user = insert(:user)

    session
    |> visit(Routes.soap_batch_path(@endpoint, :index, as: user.id))
    |> click(role("create-soap-batch"))
    |> fill_in(role("soap-batch-name-input"), with: "fff")
    |> fill_in(role("soap-batch-amount-produced-input"), with: "1000")
    |> click(role("soap-batch-submit"))
    |> assert_has(role("soap-batch-name", text: "fff"))
    |> assert_has(role("batch-amount-produced", text: "1000g"))

    session
    |> visit(Routes.soap_batch_path(@endpoint, :index))
    |> find(role("soap-batch-name", text: "fff"))
  end

  test "can edit a batch", %{session: session} do
    user = insert(:user)
    batch = insert(:soap_batch, user_id: user.id)

    session
    |> visit(Routes.soap_batch_path(@endpoint, :edit, batch.id, as: user.id))
    |> fill_in(role("soap-batch-name-input"), with: "fff")
    |> click(role("soap-batch-submit"))
    |> find(role("soap-batch-name", text: "fff"))

    session
    |> visit(Routes.soap_batch_path(@endpoint, :index))
    |> find(role("soap-batch-name", text: "fff"))
  end

  test "can delete a batch", %{session: session} do
    user = insert(:user)
    batch = insert(:soap_batch, user_id: user.id)

    session
    |> visit(Routes.soap_batch_path(@endpoint, :show, batch.id, as: user.id))
    |> accept_confirm(fn session ->
      click(session, role("soap-batch-delete"))
    end)

    refute_has(session, role("soap-batch-name", text: batch.name))
    assert current_path(session) == Routes.soap_batch_path(@endpoint, :index)
  end

  test "can add an ingredient", %{session: session} do
    user = insert(:user)
    batch = insert(:soap_batch, user_id: user.id)
    order = insert(:soap_order, user_id: user.id)
    ingredient = insert(:soap_ingredient, order_id: order.id)

    session
    |> visit(Routes.soap_batch_path(@endpoint, :show, batch.id, as: user.id))
    |> click(role("batch-add-ingredient"))
    |> fill_in(role("ingredient-label-number-input"), with: ingredient.id)
    |> fill_in(role("ingredient-amount-used-input"), with: "123")
    |> click(role("ingredient-submit"))
    |> assert_has(role("batch-ingredient", text: to_string(ingredient.id)))
  end

  test "can edit an ingredient", %{session: session} do
    user = insert(:user)
    batch = insert(:soap_batch, user_id: user.id)
    order = insert(:soap_order, user_id: user.id)
    ingredient = insert(:soap_ingredient, order_id: order.id)

    batch_ingredient =
      insert(:soap_batch_ingredient,
        amount_used: 1,
        ingredient_id: ingredient.id,
        batch_id: batch.id
      )

    session
    |> visit(Routes.soap_batch_path(@endpoint, :show, batch.id, as: user.id))
    |> click(role("batch-ingredient-#{batch_ingredient.id}"))
    |> fill_in(role("ingredient-amount-used-input"), with: "2")
    |> click(role("ingredient-submit"))
    |> assert_has(role("batch-ingredient", text: to_string(ingredient.id)))

    bi = Soap.get_batch_ingredient(user.id, batch.id, batch_ingredient.id)
    assert bi.amount_used == 2
  end

  test "can delete an ingredient", %{session: session} do
    user = insert(:user)
    batch = insert(:soap_batch, user_id: user.id)
    order = insert(:soap_order, user_id: user.id)
    ingredient = insert(:soap_ingredient, order_id: order.id)

    batch_ingredient =
      insert(:soap_batch_ingredient,
        amount_used: 1,
        ingredient_id: ingredient.id,
        batch_id: batch.id
      )

    edit_path =
      Routes.soap_batch_ingredient_path(
        @endpoint,
        :edit,
        batch.id,
        batch_ingredient.id,
        as: user.id
      )

    session
    |> visit(edit_path)
    |> accept_confirm(fn session ->
      click(session, role("ingredient-delete-button"))
    end)

    refute_has(session, role("batch-ingredient-#{batch_ingredient.id}"))
  end
end
