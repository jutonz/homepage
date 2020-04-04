defmodule ClientWeb.Api.WaterLogEntryControllerTest do
  use ClientWeb.ConnCase
  alias Client.Factory

  describe "POST /api/water-logs/:id/entries" do
    test "creates a water log", %{conn: conn} do
      user = Factory.insert(:user)
      api_token = Factory.insert(:api_token, user_id: user.id)
      log = Factory.insert(:water_log, user_id: user.id)
      path = api_water_log_entry_path(conn, :create, log.id)

      params =
        Factory.params_for(:water_log_entry, user_id: user.id, water_log_id: log.id, ml: 100)

      json =
        conn
        |> Plug.Conn.put_req_header("authorization", "Bearer #{api_token.token}")
        |> post(path, params)
        |> json_response(200)

      assert %{
               "id" => _id
             } = json
    end

    test "renders changeset errors if present", %{conn: conn} do
      user = Factory.insert(:user)
      api_token = Factory.insert(:api_token, user_id: user.id)
      log = Factory.insert(:water_log, user_id: user.id)
      path = api_water_log_entry_path(conn, :create, log.id)

      params =
        Factory.params_for(:water_log_entry, user_id: user.id, water_log_id: log.id, ml: nil)

      json =
        conn
        |> put_req_header("authorization", "Bearer #{api_token.token}")
        |> post(path, params)
        |> json_response(400)

      assert %{"error" => %{"ml" => ["can't be blank"]}} = json
    end
  end
end
