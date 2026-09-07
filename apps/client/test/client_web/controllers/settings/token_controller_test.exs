defmodule ClientWeb.Settings.TokenControllerTest do
  use ClientWeb.ConnCase

  alias Client.ApiTokens
  alias Client.ApiTokens.ApiToken
  alias Client.Repo
  alias Client.Scope

  setup do
    user = insert(:user)
    %{user: user, scope: Scope.for_user(user)}
  end

  describe "POST /settings/api/tokens" do
    test "it creates a token", %{conn: conn, user: user} do
      params = %{api_token: %{description: "laptop"}, as: user.id}

      html =
        conn
        |> post(Routes.settings_api_token_path(conn, :create), params)
        |> assert_status(302)
        |> follow_redirect()
        |> html_response(200)

      assert html =~ "laptop"
    end

    test "associates the token with the logged-in user", %{conn: conn, user: user, scope: scope} do
      params = %{api_token: %{description: "laptop"}, as: user.id}

      conn
      |> post(Routes.settings_api_token_path(conn, :create), params)
      |> assert_status(302)

      assert ApiTokens.get_by_description(scope, "laptop")
    end

    test "ignores an owner supplied in the params", %{conn: conn, user: user, scope: scope} do
      other = insert(:user)
      params = %{api_token: %{description: "laptop", user_id: other.id}, as: user.id}

      conn
      |> post(Routes.settings_api_token_path(conn, :create), params)
      |> assert_status(302)

      assert [token] = ApiTokens.list(scope)
      assert token.user_id == user.id
    end
  end

  describe "DELETE /settings/api/tokens/:id" do
    test "deletes the user's token", %{conn: conn, user: user} do
      token = insert(:api_token, user_id: user.id)

      conn = delete(conn, Routes.settings_api_token_path(conn, :delete, token.id, as: user.id))

      assert redirected_to(conn) == Routes.settings_api_path(ClientWeb.Endpoint, :show)
      refute Repo.get(ApiToken, token.id)
    end

    test "is not found for another user's token", %{conn: conn, user: user} do
      other_token = insert(:api_token)

      assert_error_sent(404, fn ->
        delete(conn, Routes.settings_api_token_path(conn, :delete, other_token.id, as: user.id))
      end)

      assert Repo.get(ApiToken, other_token.id)
    end
  end

  def assert_status(conn, status) do
    assert conn.status == status
    conn
  end

  def follow_redirect(conn) do
    [redirect_path] = get_resp_header(conn, "location")

    conn
    |> recycle()
    |> get(redirect_path)
  end
end
