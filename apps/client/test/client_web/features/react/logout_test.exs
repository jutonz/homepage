defmodule ClientWeb.React.LogoutTest do
  use ClientWeb.FeatureCase, async: true

  test "sends the user back to the login page", %{session: session} do
    user = insert(:user)

    session
    |> login(user)
    |> click(css("a", text: "Logout"))
    |> assert_has(css("h1", text: "Login"))

    assert current_url(session) == ClientWeb.Endpoint.url() <> "/#/login"
  end
end
