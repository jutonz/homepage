defmodule ClientWeb.TrainLogsTest do
  use ClientWeb.FeatureCase, async: true
  import Wallaby.Query, only: [radio_button: 1]

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

  test "can record a sighting", %{session: session} do
    user = insert(:user)
    log = insert(:train_log, user_id: user.id)

    session
    |> visit(Routes.train_log_path(@endpoint, :show, log, as: user.id))
    |> click(role("add-sighting-button"))
    |> fill_in(role("train-log-sighted-date-input"), with: "04/23/2021")
    |> fill_in(role("train-log-sighted-time-input"), with: "07:23PM")
    |> click(radio_button("south"))
    |> fill_in(role("train-log-cars-input"), with: "21")
    |> fill_in(role("train-log-numbers-input"), with: "100 200")
    |> click(role("create-train-sighting"))
    |> assert_has(role("train-sighting-row", text: "100, 200"))
  end
end
