defmodule ClientWeb.UserResolverTest do
  use ClientWeb.ConnCase, async: true
  alias Client.Auth
  alias Client.Factory

  describe "login" do
    test "returns the user and the tokens", %{conn: conn} do
      user = Factory.insert(:user, password: "password123")

      query = """
      mutation {
        login(email: "#{user.email}", password: "password123") {
          result {
            user { id email }
            accessToken
            refreshToken
          }
        }
      }
      """

      resp = conn |> post("/graphql", %{query: query}) |> json_response(200)

      result = get_in(resp, ~w[data login result])
      assert result["accessToken"]
      assert result["refreshToken"]
      assert get_in(result, ~w[user id]) == to_string(user.id)
      assert get_in(result, ~w[user email]) == user.email
    end

    test "returns an error if the password is invalid", %{conn: conn} do
      user = Factory.insert(:user, password: "password123")

      query = """
      mutation {
        login(email: "#{user.email}", password: "wrong") {
          result {
            user { id email }
            accessToken
            refreshToken
          }
          successful
          messages {
            message
          }
        }
      }
      """

      resp = conn |> post("/graphql", %{query: query}) |> json_response(200)

      refute get_in(resp, ~w[data successful])
      refute get_in(resp, ~w[data login result])
      assert [%{"message" => "Invalid email or password"}] = get_in(resp, ~w[data login messages])
    end

    test "returns an error if the user doesn't exist", %{conn: conn} do
      query = """
      mutation {
        login(email: "asdf", password: "asdf") {
          result {
            user { id email }
            accessToken
            refreshToken
          }
          successful
          messages {
            message
          }
        }
      }
      """

      resp = conn |> post("/graphql", %{query: query}) |> json_response(200)

      refute get_in(resp, ~w[data successful])
      refute get_in(resp, ~w[data login result])
      assert [%{"message" => "Invalid email or password"}] = get_in(resp, ~w[data login messages])
    end
  end

  describe "refresh_token" do
    test "returns new access and refresh tokens", %{conn: conn} do
      user = Factory.insert(:user)
      {:ok, refresh, _claims} = Auth.single_use_jwt(user, 30, "refresh")

      query = """
      mutation {
        refreshToken(refreshToken: "#{refresh}") {
          result {
            accessToken
            refreshToken
          }
          successful
          messages {
            message
          }
        }
      }
      """

      resp =
        conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert get_in(resp, ~w[data refreshToken successful])
      assert get_in(resp, ~w[data refreshToken result accessToken])
      assert get_in(resp, ~w[data refreshToken result refreshToken])
    end

    test "only allows exchanging a refresh token once", %{conn: conn} do
      user = Factory.insert(:user)

      login_query = """
      mutation {
        login(email: "#{user.email}", password: "password123") {
          result {
            user { id email }
            accessToken
            refreshToken
          }
        }
      }
      """

      conn = post(conn, "/graphql", %{query: login_query})
      login_resp = json_response(conn, 200)

      refresh_token = get_in(login_resp, ~w[data login result refreshToken])
      assert refresh_token

      refresh_query = """
      mutation {
        refreshToken(refreshToken: "#{refresh_token}") {
          result {
            accessToken
            refreshToken
          }
          successful
          messages {
            message
          }
        }
      }
      """

      resp =
        conn
        |> recycle()
        |> post("/graphql", %{query: refresh_query})
        |> recycle()
        |> post("/graphql", %{query: refresh_query})
        |> json_response(200)

      refute get_in(resp, ~w[data refreshToken successful])
    end
  end
end
