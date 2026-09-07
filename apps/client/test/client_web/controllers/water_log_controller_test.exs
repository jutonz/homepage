defmodule ClientWeb.WaterLogControllerTest do
  use ClientWeb.ConnCase, async: true

  alias Client.Repo
  alias Client.WaterLogs.WaterLog

  setup do
    user = insert(:user)
    %{user: user, log: insert(:water_log, user_id: user.id)}
  end

  describe "index/2" do
    test "lists only the user's logs", %{conn: conn, user: user, log: log} do
      other_log = insert(:water_log)

      html = conn |> get(~p"/water-logs?as=#{user.id}") |> html_response(200)

      assert html =~ log.name
      refute html =~ other_log.name
    end
  end

  describe "create/2" do
    test "takes the owner from the scope, not the params", %{conn: conn, user: user} do
      other = insert(:user)
      params = %{"name" => "kitchen", "user_id" => other.id}

      conn = post(conn, ~p"/water-logs?as=#{user.id}", water_log: params)

      log = Repo.get_by!(WaterLog, name: "kitchen")
      assert log.user_id == user.id
      assert redirected_to(conn) == ~p"/water-logs/#{log.id}"
    end
  end

  describe "show/2" do
    test "renders the user's log", %{conn: conn, user: user, log: log} do
      insert(:water_log_entry, water_log_id: log.id, ml: 250)

      html = conn |> get(~p"/water-logs/#{log.id}?as=#{user.id}") |> html_response(200)

      assert html =~ log.name
      assert html =~ "250"
    end

    test "is not found for another user's log", %{conn: conn, user: user} do
      other_log = insert(:water_log)

      assert_error_sent(404, fn ->
        get(conn, ~p"/water-logs/#{other_log.id}?as=#{user.id}")
      end)
    end

    test "does not show another user's entries", %{conn: conn, user: user, log: log} do
      other_log = insert(:water_log)
      insert(:water_log_entry, water_log_id: other_log.id, ml: 999)

      html = conn |> get(~p"/water-logs/#{log.id}?as=#{user.id}") |> html_response(200)

      refute html =~ "999"
    end
  end
end
