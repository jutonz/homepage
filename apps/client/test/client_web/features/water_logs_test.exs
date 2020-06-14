defmodule ClientWeb.WaterLogsFeatureTests do
  use ClientWeb.FeatureCase
  alias Client.WaterLogs

  test "allows adding a filter", %{session: session} do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)

    assert [] = WaterLogs.list_filters_by_log_id(log.id)

    session
    |> visit(Routes.water_log_path(@endpoint, :show, log.id, as: user.id))
    |> click(role("view-filters-button"))
    |> click(role("create-filter-button"))

    assert [filter] = WaterLogs.list_filters_by_log_id(log.id)
    assert filter.water_log_id == log.id

    session
    |> assert_has(role("water-filter-row-#{filter.id}"))
  end

  test "allows deleting a filter", %{session: session} do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)
    insert(:water_log_filter, water_log_id: log.id)

    session
    |> visit(Routes.water_log_filters_path(@endpoint, :index, log.id, as: user.id))
    |> accept_confirm(fn session ->
      click(session, role("delete-filter-button"))
    end)

    assert_has(session, role("filter-empty-state"))

    assert [] = WaterLogs.list_filters_by_log_id(log.id)
  end
end
