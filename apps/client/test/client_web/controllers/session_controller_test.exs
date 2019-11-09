defmodule ClientWeb.SessionControllerTest do
  use ClientWeb.ConnCase, async: true

  describe "GET /api/tokentest" do
    test "responds 401 if the token is missing", %{conn: conn} do
      conn = get(conn, session_path(conn, :token_test))
      assert conn.status == 401
    end

    test "responds with info about the token", %{conn: conn} do
      api_token = insert(:api_token)
      user = Client.Repo.get(Client.User, api_token.user_id)

      {response, conn} =
        conn
        |> put_req_header("authorization", "Bearer #{api_token.token}")
        |> get(session_path(conn, :token_test))
        |> json_response()

      assert conn.status == 200

      assert response == %{
               "current_user" => %{
                 "email" => user.email
               },
               "token" => %{
                 "description" => api_token.description
               }
             }
    end
  end

  defp json_response(conn),
    do: {Jason.decode!(conn.resp_body), conn}
end
