defmodule ClientWeb.WaterLogsFeatureTests do
  use ClientWeb.FeatureCase, async: true
  alias Client.Scope
  alias Client.WaterLogs

  test "allows adding a filter", %{session: session} do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)

    assert [] = list_filters(user, log.id)

    session
    |> visit(Routes.water_log_path(@endpoint, :show, log.id, as: user.id))
    |> click(role("view-filters-button"))
    |> click(role("create-filter-button"))
    |> fill_in(role("water-filter-lifespan-input"), with: "2000")
    |> click(role("create-water-filter"))
    |> assert_has(css("[data-role^='water-filter-row']"))

    assert [filter] = list_filters(user, log.id)
    assert filter.water_log_id == log.id
    assert filter.lifespan == 2000

    session
    |> assert_has(role("water-filter-row-#{filter.id}"))
  end

  test "allows updating a filter", %{session: session} do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)
    filter = insert(:water_log_filter, water_log_id: log.id, lifespan: 1000)

    session
    |> visit(Routes.water_log_filters_path(@endpoint, :index, log.id, as: user.id))
    |> click(role("edit-filter-button"))
    |> fill_in(role("water-filter-lifespan-input"), with: "2000")
    |> click(role("update-water-filter"))
    |> assert_has(role("water-filter-row-#{filter.id}", text: "2000"))

    assert [filter] = list_filters(user, log.id)
    assert filter.water_log_id == log.id
    assert filter.lifespan == 2000
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

    assert [] = list_filters(user, log.id)
  end

  defp list_filters(user, log_id),
    do: user |> Scope.for_user() |> WaterLogs.list_filters(log_id)
end
