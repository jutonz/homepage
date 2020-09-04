defmodule ClientWeb.Settings.TokenControllerTest do
  use ClientWeb.ConnCase
  alias Client.ApiTokens

  describe "POST /settings/api/tokens" do
    test "it creates a token", %{conn: conn} do
      user = insert(:user)
      token_params = params_for(:api_token, user_id: user.id)
      params = %{api_token: token_params, as: user.id}

      html =
        conn
        |> post(Routes.settings_api_token_path(conn, :create), params)
        |> assert_status(302)
        |> follow_redirect()
        |> html_response(200)

      assert html =~ params[:api_token][:description]
    end

    test "associates the token with the logged-in user", %{conn: conn} do
      user = insert(:user)
      token_params = params_for(:api_token, user_id: user.id)
      params = %{api_token: token_params, as: user.id}

      conn
      |> post(Routes.settings_api_token_path(conn, :create), params)
      |> assert_status(302)

      assert ApiTokens.get_by_description(user.id, token_params[:description])
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
