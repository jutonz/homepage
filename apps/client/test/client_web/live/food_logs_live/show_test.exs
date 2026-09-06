defmodule ClientWeb.FoodLogsLive.ShowTest do
  use ClientWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias Client.FoodLogs
  alias Client.Repo

  setup do
    user = insert(:user)
    %{user: user, log: insert(:food_log, owner_id: user.id)}
  end

  test "shows the user's log", %{conn: conn, user: user, log: log} do
    entry = insert(:food_log_entry, food_log_id: log.id)

    {:ok, _live, html} = live(conn, ~p"/food-logs/#{log.id}?as=#{user.id}")

    assert html =~ log.name
    assert html =~ entry.description
  end

  test "does not show entries in another user's log", %{conn: conn, user: user, log: log} do
    theirs = insert(:food_log_entry, food_log_id: insert(:food_log).id)

    {:ok, _live, html} = live(conn, ~p"/food-logs/#{log.id}?as=#{user.id}")

    refute html =~ theirs.description
  end

  test "is not found for another user's log", %{conn: conn, user: user} do
    other_log = insert(:food_log)

    assert_error_sent(404, fn ->
      get(conn, ~p"/food-logs/#{other_log.id}?as=#{user.id}")
    end)
  end

  test "redirects rather than crashing when the log goes away before connecting", %{
    conn: conn,
    user: user,
    log: log
  } do
    conn = get(conn, ~p"/food-logs/#{log.id}?as=#{user.id}")
    Repo.delete!(log)

    assert {:error, {:redirect, %{to: "/food-logs"}}} = live(conn)
  end

  test "adds an entry owned by the log and logged by the user", %{
    conn: conn,
    user: user,
    log: log
  } do
    {:ok, live, _html} = live(conn, ~p"/food-logs/#{log.id}?as=#{user.id}")

    live
    |> form("form", entry: %{description: "toast"})
    |> render_submit()

    assert render(live) =~ "toast"

    assert [entry] =
             FoodLogs.list_entries_occurred_between(
               build(:scope, user: user),
               log.id,
               long_ago(),
               soon()
             )

    assert entry.description == "toast"
    assert entry.user_id == user.id
  end

  defp long_ago, do: ~N[2000-01-01 00:00:00]

  defp soon, do: NaiveDateTime.add(NaiveDateTime.utc_now(), 60 * 60 * 24)
end
