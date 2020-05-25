defmodule ClientWeb.SoapBatchesFeatureTests do
  use ClientWeb.FeatureCase

  test "can create a batch", %{session: session} do
    user = insert(:user)

    session
    |> visit(soap_batch_path(@endpoint, :index, as: user.id))
    |> click(role("create-soap-batch"))
    |> fill_in(role("soap-batch-name-input"), with: "fff")
    |> fill_in(role("soap-batch-amount-produced-input"), with: "1000")
    |> click(role("soap-batch-submit"))
    |> assert_has(role("soap-batch-name", text: "fff"))
    |> assert_has(role("batch-amount-produced", text: "1000g"))

    session
    |> visit(soap_batch_path(@endpoint, :index))
    |> find(role("soap-batch-name", text: "fff"))
  end

  test "can edit a batch", %{session: session} do
    user = insert(:user)
    batch = insert(:soap_batch, user_id: user.id)

    session
    |> visit(soap_batch_path(@endpoint, :edit, batch.id, as: user.id))
    |> fill_in(role("soap-batch-name-input"), with: "fff")
    |> click(role("soap-batch-submit"))
    |> find(role("soap-batch-name", text: "fff"))

    session
    |> visit(soap_batch_path(@endpoint, :index))
    |> find(role("soap-batch-name", text: "fff"))
  end

  test "can delete a batch", %{session: session} do
    user = insert(:user)
    batch = insert(:soap_batch, user_id: user.id)

    session
    |> visit(soap_batch_path(@endpoint, :show, batch.id, as: user.id))
    |> accept_confirm(fn session ->
      click(session, role("soap-batch-delete"))
    end)

    refute_has(session, role("soap-batch-name", text: batch.name))
    assert current_path(session) == soap_batch_path(@endpoint, :index)
  end
end
