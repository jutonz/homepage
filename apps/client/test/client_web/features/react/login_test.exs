defmodule ClientWeb.React.LoginTest do
  use ClientWeb.FeatureCase, async: true

  test "authenticates a user", %{session: session} do
    user = insert(:user)

    session
    |> login(user)
  end
end
