defmodule ClientWeb.Settings.ApiControllerTest do
  use ClientWeb.ConnCase, async: true

  describe "show/2" do
    test "lists only the user's tokens", %{conn: conn} do
      user = insert(:user)
      token = insert(:api_token, user_id: user.id, description: "mine")
      other_token = insert(:api_token, description: "theirs")

      html =
        conn
        |> get(Routes.settings_api_path(conn, :show, as: user.id))
        |> html_response(200)

      assert html =~ token.description
      refute html =~ other_token.description
    end
  end
end
