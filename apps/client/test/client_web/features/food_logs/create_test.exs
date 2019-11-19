defmodule ClientWeb.FoodLogs.CreateTest do
  use ClientWeb.FeatureCase, async: true
  import Wallaby.Query, only: [css: 2]

  test "it allows creating food logs", %{session: session} do
    name = "name"

    # TODO: figure out auth
    session
    |> visit(food_log_path(ClientWeb.Endpoint, :index))
    |> click(role("new-food-log"))
    |> fill_in(role("food-log-name-input"), with: name)
    |> click(role("new-food-log"))
    |> assert_has(css("a", text: name))
  end
end
