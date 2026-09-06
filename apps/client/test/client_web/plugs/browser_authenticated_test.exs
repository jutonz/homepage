defmodule ClientWeb.Plugs.BrowserAuthenticatedTest do
  use ClientWeb.ConnCase, async: true
  alias Client.Scope
  alias ClientWeb.Plugs.BrowserAuthenticated

  test "assigns a scope for the session's user" do
    user = insert(:user)

    conn = user.id |> with_session() |> BrowserAuthenticated.call(%{})

    assert %Scope{user: scoped_user} = conn.assigns.scope
    assert scoped_user.id == user.id
    refute conn.halted
  end

  test "redirects to login when there is no session" do
    conn =
      request()
      |> Plug.Test.init_test_session(%{})
      |> BrowserAuthenticated.call(%{})

    assert conn.halted
    assert redirected_to(conn) == "/#/login?to=/food-logs"
  end

  test "leaves an unrelated session alone when there is no user" do
    conn =
      request()
      |> Plug.Test.init_test_session(%{cart: "keep me"})
      |> BrowserAuthenticated.call(%{})

    assert conn.halted
    assert get_session(conn, :cart) == "keep me"
  end

  test "clears the session and redirects when the user no longer exists" do
    user = insert(:user)
    Client.Repo.delete!(user)

    conn = user.id |> with_session() |> BrowserAuthenticated.call(%{})

    assert conn.halted
    assert redirected_to(conn) =~ "/#/login"
    assert get_session(conn, :user_id) == nil
    refute conn.assigns[:scope]
  end

  defp request, do: Phoenix.ConnTest.build_conn(:get, "/food-logs")

  defp with_session(user_id) do
    request() |> Plug.Test.init_test_session(%{user_id: user_id})
  end
end
