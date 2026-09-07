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

  test "keeps a past day's entries when that day is told to refresh", %{
    conn: conn,
    user: user,
    log: log
  } do
    three_days_ago = NaiveDateTime.add(NaiveDateTime.utc_now(), -3, :day)
    entry = insert(:food_log_entry, food_log_id: log.id, occurred_at: three_days_ago)

    {:ok, live, html} = live(conn, ~p"/food-logs/#{log.id}?as=#{user.id}")
    assert html =~ entry.description

    send(live.pid, {:entry_updated, entry})
    await_day_refresh(live)

    assert render(live) =~ entry.description
  end

  test "groups an evening entry under its local day, not the UTC one", %{
    conn: conn,
    user: user,
    log: log
  } do
    local_day = Date.add(today(), -3)
    entry = insert(:food_log_entry, food_log_id: log.id, occurred_at: evening_of(local_day))

    {:ok, _live, html} = live(conn, ~p"/food-logs/#{log.id}?as=#{user.id}")

    assert html =~ entry.description
    assert html =~ heading(local_day)
    refute html =~ heading(Date.add(local_day, 1))
  end

  test "shows an entry logged this evening, whose UTC date is already tomorrow", %{
    conn: conn,
    user: user,
    log: log
  } do
    today = today()
    entry = insert(:food_log_entry, food_log_id: log.id, occurred_at: evening_of(today))

    {:ok, _live, html} = live(conn, ~p"/food-logs/#{log.id}?as=#{user.id}")

    assert html =~ entry.description
    assert html =~ heading(today)
  end

  test "gives each entry its own dom id", %{conn: conn, user: user, log: log} do
    one = insert(:food_log_entry, food_log_id: log.id)
    two = insert(:food_log_entry, food_log_id: log.id)

    {:ok, _live, html} = live(conn, ~p"/food-logs/#{log.id}?as=#{user.id}")

    assert html =~ ~s(id="entry-#{one.id}")
    assert html =~ ~s(id="entry-#{two.id}")
  end

  defp timezone, do: Application.fetch_env!(:client, :default_timezone)

  defp today, do: timezone() |> DateTime.now!() |> DateTime.to_date()

  defp heading(date), do: Calendar.strftime(date, "%-d %b %Y")

  defp evening_of(date) do
    date
    |> DateTime.new!(~T[21:00:00], timezone())
    |> DateTime.shift_zone!("Etc/UTC")
    |> DateTime.to_naive()
    |> NaiveDateTime.truncate(:second)
  end

  defp await_day_refresh(live), do: render(live)

  defp long_ago, do: ~N[2000-01-01 00:00:00]

  defp soon, do: NaiveDateTime.add(NaiveDateTime.utc_now(), 60 * 60 * 24)
end
