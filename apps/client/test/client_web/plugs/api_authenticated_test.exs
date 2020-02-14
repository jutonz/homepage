defmodule ClientWeb.Plugs.ApiAuthenticatedTest do
  use ClientWeb.ConnCase, async: true
  alias ClientWeb.Plugs.ApiAuthenticated

  test "sets current_user_id", %{conn: conn} do
    api_token = insert(:api_token)

    conn = conn |> authorize(api_token) |> ApiAuthenticated.call(%{})

    assert conn.assigns[:current_user_id] == api_token.user_id
  end

  test "sets the api_token", %{conn: conn} do
    api_token = insert(:api_token)

    conn = conn |> authorize(api_token) |> ApiAuthenticated.call(%{})

    assert conn.assigns[:api_token] == api_token
  end

  test "says if no auth header is present", %{conn: conn} do
    conn = ApiAuthenticated.call(conn, %{})

    assert conn.status == 401
    assert conn.resp_body == "No authorization header present"
  end

  test "says if the auth header is misformatted", %{conn: conn} do
    conn =
      conn
      |> Plug.Conn.put_req_header("authorization", "bad")
      |> ApiAuthenticated.call(%{})

    assert conn.status == 401
    assert conn.resp_body == "Authorization header should contain \"Bearer <token>\""
  end

  test "says if the auth token is invalid", %{conn: conn} do
    conn =
      conn
      |> Plug.Conn.put_req_header("authorization", "Bearer doesnt-exist")
      |> ApiAuthenticated.call(%{})

    assert conn.status == 401
    assert conn.resp_body == "The authorization header contains an invalid token"
  end

  defp authorize(conn, api_token) do
    auth_header = "Bearer #{api_token.token}"
    Plug.Conn.put_req_header(conn, "authorization", auth_header)
  end
end
