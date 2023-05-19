defmodule ClientWeb.Api.SessionControllerTest do
  use ClientWeb.ConnCase, async: true

  alias Client.{
    Auth,
    Factory,
    Session
  }

  describe "exchange" do
    test "renders 401 for an invalid jwt", %{conn: conn} do
      jwt = "abc123"
      path = Routes.api_session_path(conn, :exchange, token: jwt)

      {response, conn} = conn |> get(path) |> json_response()

      assert conn.status == 401
      assert response["messages"] == ["invalid_token"]
    end

    test "redirects to /#/", %{conn: conn} do
      user = Factory.insert(:user)
      {:ok, jwt, _claims} = Auth.single_use_jwt(user.id)
      path = Routes.api_session_path(conn, :exchange, token: jwt)

      conn
      |> get(path)
      |> assert_redirected_to("/#/")
    end

    test "can redirect to a custom path", %{conn: conn} do
      user = Factory.insert(:user)
      {:ok, jwt, _claims} = Auth.single_use_jwt(user.id)
      params = [token: jwt, to: "/wee"]
      path = Routes.api_session_path(conn, :exchange, params)

      conn
      |> get(path)
      |> assert_redirected_to("/wee")
    end
  end

  describe "token_test" do
    test "responds 401 if the token is missing", %{conn: conn} do
      conn = get(conn, Routes.api_session_path(conn, :token_test))
      assert conn.status == 401
    end

    test "responds with info about the token", %{conn: conn} do
      api_token = Factory.insert(:api_token)
      user = Client.Repo.get(Client.User, api_token.user_id)

      {response, conn} =
        conn
        |> put_req_header("authorization", "Bearer #{api_token.token}")
        |> get(Routes.api_session_path(conn, :token_test))
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

  describe "one_time_login_link" do
    test "responds 401 if the request is unauthenticated", %{conn: conn} do
      path = Routes.api_session_path(conn, :one_time_login_link)

      conn = post(conn, path)

      assert conn.status == 401
    end

    test "following the link logs a user in", %{conn: conn} do
      user = Factory.insert(:user)
      token = Factory.insert(:api_token, user_id: user.id)
      path = Routes.api_session_path(conn, :one_time_login_link)

      {response, conn} =
        conn
        |> put_auth_header(token)
        |> post(path)
        |> json_response()

      conn =
        conn
        |> recycle()
        |> get(response["url"])

      assert conn.status == 302
      assert Plug.Conn.get_resp_header(conn, "location") == ["/#/"]
    end

    test "redirects to a custom path if asked", %{conn: conn} do
      user = Factory.insert(:user)
      token = Factory.insert(:api_token, user_id: user.id)
      redirect_path = "/hello"
      params = [to: redirect_path]
      path = Routes.api_session_path(conn, :one_time_login_link, params)

      {response, conn} =
        conn
        |> put_auth_header(token)
        |> post(path)
        |> json_response()

      conn
      |> recycle()
      |> get(response["url"])
      |> assert_redirected_to(redirect_path)
    end
  end

  describe "logout" do
    test "drops the session", %{conn: conn} do
      {:ok, conn} =
        conn
        |> Plug.Test.init_test_session(%{})
        |> Session.init_user_session(Factory.insert(:user))

      conn = post(conn, Routes.api_session_path(conn, :logout))

      assert redirected_to(conn) == "/"
      assert Session.current_user_id(conn) == nil
    end
  end

  defp json_response(conn),
    do: {Jason.decode!(conn.resp_body), conn}

  @spec put_auth_header(Plug.Conn.t(), Client.AuthTokens.AuthToken.t()) :: Plug.Conn.t()
  defp put_auth_header(conn, token) do
    Plug.Conn.put_req_header(conn, "authorization", "Bearer #{token.token}")
  end

  defp assert_redirected_to(conn, path) do
    assert conn.status == 302
    assert Plug.Conn.get_resp_header(conn, "location") == [path]
  end
end
