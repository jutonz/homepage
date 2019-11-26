defmodule ClientWeb.FoodLogs.UpdateTest do
  use ClientWeb.FeatureCase

  test "it allows updating food logs", %{session: session} do
    user = insert(:user)
    log = insert(:food_log, owner_id: user.id)
    new_name = "new name!"

    session
    |> visit(food_log_path(ClientWeb.Endpoint, :show, log.id, as: user.id))
    |> click(role("edit-food-log"))
    |> fill_in(role("food-log-name-input"), with: new_name)
    |> click(role("update-food-log"))
    |> assert_has(role("food-log-title", text: new_name))
  end
end
