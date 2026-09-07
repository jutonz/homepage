defmodule ClientWeb.Api.WaterLogEntryControllerTest do
  use ClientWeb.ConnCase
  alias Client.Factory
  alias Client.Repo
  alias Client.WaterLogs.Entry

  setup %{conn: conn} do
    user = Factory.insert(:user)
    api_token = Factory.insert(:api_token, user_id: user.id)
    log = Factory.insert(:water_log, user_id: user.id)

    conn = Plug.Conn.put_req_header(conn, "authorization", "Bearer #{api_token.token}")

    %{conn: conn, user: user, log: log}
  end

  describe "POST /api/water-logs/:water_log_id/entries" do
    test "creates an entry owned by the token's user", %{conn: conn, user: user, log: log} do
      path = Routes.api_water_log_entry_path(conn, :create, log.id)

      json = conn |> post(path, %{"ml" => 100}) |> json_response(200)

      assert %{"id" => id, "ml" => 100} = json
      entry = Repo.get!(Entry, id)
      assert entry.user_id == user.id
      assert entry.water_log_id == log.id
    end

    test "takes the owner from the scope, not the params", %{conn: conn, user: user, log: log} do
      other = Factory.insert(:user)
      path = Routes.api_water_log_entry_path(conn, :create, log.id)

      json = conn |> post(path, %{"ml" => 100, "user_id" => other.id}) |> json_response(200)

      assert Repo.get!(Entry, json["id"]).user_id == user.id
    end

    test "is not found for another user's log", %{conn: conn} do
      other_log = Factory.insert(:water_log)
      path = Routes.api_water_log_entry_path(conn, :create, other_log.id)

      assert_error_sent(404, fn -> post(conn, path, %{"ml" => 100}) end)
    end

    test "renders changeset errors if present", %{conn: conn, log: log} do
      path = Routes.api_water_log_entry_path(conn, :create, log.id)

      json = conn |> post(path, %{"ml" => nil}) |> json_response(400)

      assert %{"error" => %{"ml" => ["can't be blank"]}} = json
    end
  end
end
