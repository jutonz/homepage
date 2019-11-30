defmodule ClientWeb.FoodLogs.AddEntryTest do
  use ClientWeb.FeatureCase

  test "it allows adding entries to food logs", %{session: session} do
    user = insert(:user)
    log = insert(:food_log, owner_id: user.id)
    desc = "food!"

    session
    |> visit(food_log_path(ClientWeb.Endpoint, :show, log.id, as: user.id))
    |> click(role("entry-add"))
    |> fill_in(role("entry-desc-input"), with: desc)
    |> click(role("entry-submit"))
    |> assert_has(role("food-log-entry", text: desc))
  end
end
