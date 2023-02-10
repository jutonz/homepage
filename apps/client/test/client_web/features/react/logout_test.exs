defmodule ClientWeb.React.LogoutTest do
  use ClientWeb.FeatureCase, async: true
  import Wallaby.Query, only: [link: 1]

  test "sends the user back to the login page", %{session: session} do
    user = insert(:user)

    session
    |> login(user)
    |> click(link("Logout"))

    assert current_path(session) === "/#/login"
  end
end
