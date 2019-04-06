defmodule ClientWeb.UserListTest do
  use ClientWeb.FeatureCase, async: true

  import Wallaby.Query, only: [css: 2]

  test "users have names", %{session: session} do
    session
    |> visit("/twitch/channels/yo")
    |> assert_has(css(".channel", text: "Hey yo"))
  end
end
