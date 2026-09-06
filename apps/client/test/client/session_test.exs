defmodule Client.SessionTest do
  use Client.DataCase, async: true
  alias Client.Session

  describe "current_user_id/1" do
    test "reads the id out of a conn's session" do
      user = insert(:user)
      conn = Phoenix.ConnTest.build_conn() |> Plug.Test.init_test_session(%{user_id: user.id})

      assert Session.current_user_id(conn) == user.id
    end

    # Nested LiveViews are handed a user id rather than a scope, since only
    # serializable values survive the trip through live_render/3.
    test "reads the id out of a LiveView session map" do
      assert Session.current_user_id(%{"user_id" => 42}) == 42
    end

    test "is nil when the session names nobody" do
      assert Session.current_user_id(%{}) == nil

      assert Session.current_user_id(
               Phoenix.ConnTest.build_conn()
               |> Plug.Test.init_test_session(%{})
             ) == nil
    end
  end
end
