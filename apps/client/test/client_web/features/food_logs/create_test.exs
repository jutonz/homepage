defmodule ClientWeb.FoodLogs.CreateTest do
  use ClientWeb.FeatureCase

  test "it allows creating food logs", %{session: session} do
    user = insert(:user)
    name = "name"

    session
    |> visit(food_log_path(ClientWeb.Endpoint, :index, as: user.id))
    |> click(role("new-food-log"))
    |> fill_in(role("food-log-name-input"), with: name)
    |> click(role("create-food-log"))
    |> assert_has(role("food-log-title", text: name))
  end
end
