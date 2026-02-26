defmodule ClientWeb.FoodLogsTest do
  use ClientWeb.FeatureCase, async: true
  import Wallaby.Query
  alias Client.FoodLogs

  test "it allows creating food logs", %{session: session} do
    user = insert(:user)
    name = "name"

    session
    |> visit("/food-logs?as=#{user.id}")
    |> click(role("new-food-log"))
    |> fill_in(role("food-log-name-input"), with: name)
    |> click(role("create-food-log"))
    |> assert_has(role("food-log-title", text: name))
  end

  test "it has breadcrumbs", %{session: session} do
    user = insert(:user)
    log = insert(:food_log, owner_id: user.id)

    session
    |> visit("/food-logs/#{log.id}?as=#{user.id}")
    |> click(link("Food Logs"))

    assert current_path(session) == "/food-logs"
  end

  test "it allows updating food logs", %{session: session} do
    user = insert(:user)
    log = insert(:food_log, owner_id: user.id)
    new_name = "new name!"

    session
    |> visit("/food-logs/#{log.id}?as=#{user.id}")
    |> click(link("Edit"))
    |> fill_in(role("food-log-name-input"), with: new_name)
    |> click(role("update-food-log"))
    |> assert_has(role("food-log-title", text: new_name))
  end

  test "it allows adding entries to food logs", %{session: session} do
    user = insert(:user)
    log = insert(:food_log, owner_id: user.id)
    desc = "food!"

    session
    |> visit("/food-logs/#{log.id}?as=#{user.id}")
    |> fill_in(role("entry-desc-input"), with: desc)
    |> click(role("entry-submit"))
    |> assert_has(role("food-log-entry", text: desc))
  end

  test "it allows editing entries", %{session: session} do
    user = insert(:user)
    log = insert(:food_log, owner_id: user.id)
    entry = insert(:food_log_entry, food_log_id: log.id, user_id: user.id)
    new_desc = "wee"

    session
    |> visit("/food-logs/#{log.id}?as=#{user.id}")
    |> click(entry_selector(entry.id))
    |> fill_in(role("entry-desc-update-input"), with: new_desc)
    |> click(role("entry-update-submit"))
    |> assert_has(role("food-log-entry", text: new_desc))
  end

  test "it allows editing occurred at", %{session: session} do
    user = insert(:user)
    log = insert(:food_log, owner_id: user.id)
    entry = insert(:food_log_entry, food_log_id: log.id, user_id: user.id)
    date = "2020-01-01"
    time = "13:00:00"
    {:ok, iso_time, _offset} = DateTime.from_iso8601("2020-01-01T13:00:00-05:00")
    iso_time = iso_time |> to_string() |> String.replace(" ", "T")

    session
    |> visit("/food-logs/#{log.id}?as=#{user.id}")
    |> click(entry_selector(entry.id))
    |> find(css("#entry_occurred_at_date"))
    |> execute_script("document.getElementById('entry_occurred_at_date').value = '#{date}'")
    |> execute_script("document.getElementById('entry_occurred_at_time').value = '#{time}'")

    session
    |> click(role("entry-update-submit"))
    |> take_screenshot()

    updated_entry = FoodLogs.get_entry(entry.id)

    updated_occurred_at =
      updated_entry.occurred_at
      |> NaiveDateTime.add(5 * 60 * 60, :second)
      |> NaiveDateTime.to_iso8601()

    assert iso_time == "#{updated_occurred_at}Z"
  end

  test "it allows deleting entries", %{session: session} do
    user = insert(:user)
    log = insert(:food_log, owner_id: user.id)
    entry = insert(:food_log_entry, food_log_id: log.id, user_id: user.id)

    session
    |> visit("/food-logs/#{log.id}?as=#{user.id}")
    |> click(entry_selector(entry.id))
    |> assert_has(role("delete-log-entry"))
    |> accept_confirm(fn session ->
      click(session, role("delete-log-entry"))
    end)

    assert_has(session, css("body"))
    refute_has(session, entry_selector(entry.id))
    refute FoodLogs.get_entry(entry.id)
  end

  defp entry_selector(entry_id),
    do: css(~s([data-role="food-log-entry"][data-entry-id="#{entry_id}"]))
end
