defmodule ClientWeb.FoodLogs.AddEntryTest do
  use ClientWeb.FeatureCase

  test "it allows creating food logs", %{session: session} do
    user = insert(:user)
    name = "name"

    session
    |> visit(food_log_path(@endpoint, :index, as: user.id))
    |> click(role("new-food-log"))
    |> fill_in(role("food-log-name-input"), with: name)
    |> click(role("create-food-log"))
    |> assert_has(role("food-log-title", text: name))
  end

  test "it has breadcrumbs", %{session: session} do
    user = insert(:user)
    log = insert(:food_log, owner_id: user.id)

    session
    |> visit(food_log_path(@endpoint, :show, log.id, as: user.id))
    |> click(role("food-log-bc-to-index"))

    index_path = food_log_path(@endpoint, :index)
    assert current_path(session) == index_path
  end

  test "it allows updating food logs", %{session: session} do
    user = insert(:user)
    log = insert(:food_log, owner_id: user.id)
    new_name = "new name!"

    session
    |> visit(food_log_path(@endpoint, :show, log.id, as: user.id))
    |> click(role("edit-food-log"))
    |> fill_in(role("food-log-name-input"), with: new_name)
    |> click(role("update-food-log"))
    |> assert_has(role("food-log-title", text: new_name))
  end

  test "it allows adding entries to food logs", %{session: session} do
    user = insert(:user)
    log = insert(:food_log, owner_id: user.id)
    desc = "food!"

    session
    |> visit(food_log_path(@endpoint, :show, log.id, as: user.id))
    |> fill_in(role("entry-desc-input"), with: desc)
    |> click(role("entry-submit"))
    |> assert_has(role("food-log-entry", text: desc))
  end
end
