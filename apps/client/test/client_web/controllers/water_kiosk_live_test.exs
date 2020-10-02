defmodule ClientWeb.WaterLogKioskLiveTest do
  use ClientWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  @controller ClientWeb.WaterLogKioskLive

  test "it renders", %{conn: conn} do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)
    path = Routes.water_log_live_path(conn, @controller, log.id, as: user.id)

    {:ok, _view, html} = live(conn, path)

    assert html =~ "Waiting for activity"
    assert html =~ "Total dispensed: 0 ml"
  end

  test "displays the ml count when receiving a pubsub event", %{conn: conn} do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)
    path = Routes.water_log_live_path(conn, @controller, log.id, as: user.id)

    {:ok, view, html} = live(conn, path)
    assert html =~ "Waiting for activity"

    publish_event(log.id, {:set_ml, %{"ml" => 123}})
    assert render(view) =~ "Dispensed 123 ml"
  end

  test "shows a saving state when asked to", %{conn: conn} do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)
    path = Routes.water_log_live_path(conn, @controller, log.id, as: user.id)
    {:ok, view, _html} = live(conn, path)

    ml = 123
    publish_event(log.id, {:saving, %{"ml" => ml}})

    assert render(view) =~ "Saving"
  end

  test "resets when saving is successful", %{conn: conn} do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)
    path = Routes.water_log_live_path(conn, @controller, log.id, as: user.id)
    {:ok, view, _html} = live(conn, path)

    ml = 123
    publish_event(log.id, {:set_ml, %{"ml" => ml}})
    assert render(view) =~ "Dispensed #{ml} ml"

    publish_event(log.id, {:saving, %{"ml" => ml}})
    assert render(view) =~ "Saving"

    publish_event(log.id, :saved)
    html = render(view)
    refute html =~ "Saving"
    refute html =~ "Dispensed #{ml} ml"
    assert html =~ "Waiting for activity"
  end

  test "updates dispensed amount after saving", %{conn: conn} do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)
    path = Routes.water_log_live_path(conn, @controller, log.id, as: user.id)

    {:ok, view, html} = live(conn, path)
    assert html =~ "Total dispensed: 0 ml"
    assert html =~ "Dispensed today: 0 ml"

    insert(:water_log_entry, water_log_id: log.id, ml: 3000)
    publish_event(log.id, :saved)
    assert render(view) =~ "Dispensed today: 3,000 ml"
    assert render(view) =~ "Total dispensed: 3,000 ml"
  end

  test "shows and updates filter life if applicable", %{conn: conn} do
    user = insert(:user)
    yesterday = Timex.now() |> Timex.shift(days: -1)
    log = insert(:water_log, user_id: user.id, inserted_at: yesterday)
    insert(:water_log_filter, water_log_id: log.id, lifespan: 2000, inserted_at: yesterday)
    path = Routes.water_log_live_path(conn, @controller, log.id, as: user.id)

    {:ok, view, html} = live(conn, path)
    assert html =~ "Filter life remaining: 2000 L"

    insert(:water_log_entry,
      water_log_id: log.id,
      ml: 1000,
      inserted_at: Timex.shift(yesterday, hours: 1)
    )

    publish_event(log.id, :saved)
    assert render(view) =~ "Filter life remaining: 1999 L"
  end

  test "shows and updates the current weight", %{conn: conn} do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)
    path = Routes.water_log_live_path(conn, @controller, log.id, as: user.id)

    {:ok, view, html} = live(conn, path)
    assert html =~ "Current weight: 0 g"

    publish_event(log.id, {:weight, 100})
    assert render(view) =~ "Current weight: 100 g"
  end

  defp publish_event(log_id, event) do
    Phoenix.PubSub.broadcast!(
      Client.PubSub,
      "water_log_internal:#{log_id}",
      event
    )
  end
end
