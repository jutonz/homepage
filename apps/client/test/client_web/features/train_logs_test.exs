defmodule ClientWeb.TrainLogsTest do
  use ClientWeb.FeatureCase, async: true

  test "can create a train log", %{session: session} do
    user = insert(:user)
    location = "Location!"

    session
    |> visit(Routes.train_log_path(@endpoint, :index, as: user.id))
    |> click(role("new-train-log"))
    |> fill_in(role("train-log-location-input"), with: location)
    |> click(role("create-train-log"))
    |> assert_has(role("train-log-link", text: location))
  end
end
