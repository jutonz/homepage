defmodule ClientWeb.WaterLogKioskLiveTest do
  use ClientWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  @controller ClientWeb.WaterLogKioskLive

  test "it renders", %{conn: conn} do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)
    path = Routes.water_log_live_path(conn, @controller, log.id, as: user.id)

    {:ok, _view, html} = live(conn, path)

    assert html =~ "Total dispensed: 0 L"
  end

  test "updates usage as events come in", %{conn: conn} do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)
    path = Routes.water_log_live_path(conn, @controller, log.id, as: user.id)
    insert(:water_log_entry, water_log_id: log.id, ml: 1000, inserted_at: now())

    {:ok, view, html} = live(conn, path)
    assert html =~ "Dispensed now: 0 ml"
    assert today_usage(html) == "1000"

    publish_event(log.id, {:set_ml, %{"ml" => 234}})
    html = render(view)
    assert html =~ "Dispensed now: 234 ml"
    assert today_usage(html) == "1234"
  end

  test "resets usage after an entry is added", %{conn: conn} do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)
    path = Routes.water_log_live_path(conn, @controller, log.id, as: user.id)
    insert(:water_log_entry, water_log_id: log.id, ml: 1000)

    {:ok, view, html} = live(conn, path)
    assert html =~ "Dispensed now: 0 ml"
    assert today_usage(html) == "1000"

    publish_event(log.id, {:set_ml, %{"ml" => 234}})
    html = render(view)
    assert today_usage(html) == "1234"
    assert html =~ "Dispensed now: 234 ml"

    insert(:water_log_entry, water_log_id: log.id, ml: 234)
    publish_event(log.id, :saved)
    html = render(view)
    assert today_usage(html) == "1234"
    assert html =~ "Dispensed now: 0 ml"
  end

  test "shows filter life if applicable", %{conn: conn} do
    user = insert(:user)
    yesterday = Timex.now() |> Timex.shift(days: -1)
    log = insert(:water_log, user_id: user.id, inserted_at: yesterday)
    insert(:water_log_filter, water_log_id: log.id, lifespan: 2000, inserted_at: yesterday)
    path = Routes.water_log_live_path(conn, @controller, log.id, as: user.id)

    insert(:water_log_entry,
      water_log_id: log.id,
      ml: 1000,
      inserted_at: Timex.shift(yesterday, hours: 1)
    )

    {:ok, _view, html} = live(conn, path)
    assert html =~ "Filter life remaining: 1999 L"
  end

  test "shows and updates the current weight", %{conn: conn} do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)
    path = Routes.water_log_live_path(conn, @controller, log.id, as: user.id)

    {:ok, view, html} = live(conn, path)
    assert html =~ "Weight: 0 g"

    publish_event(log.id, {:weight, 100})
    assert render(view) =~ "Weight: 100 g"
  end

  defp publish_event(log_id, event) do
    Phoenix.PubSub.broadcast!(
      Client.PubSub,
      "water_log_internal:#{log_id}",
      event
    )
  end

  defp today_usage(html) do
    html
    |> Floki.parse_document!()
    |> Floki.find("[data-role='usage-for-Today']")
    |> Floki.text()
    |> String.trim()
  end

  def now do
    :client |> Application.get_env(:default_timezone) |> Timex.now()
  end
end
