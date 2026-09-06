defmodule ClientWeb.Live.AssignScopeTest do
  use ClientWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  alias Client.Scope
  alias ClientWeb.Live.AssignScope

  describe "on_mount/4" do
    test "assigns a scope for the session's user" do
      user = insert(:user)

      assert {:cont, socket} =
               AssignScope.on_mount(:default, %{}, %{"user_id" => user.id}, socket())

      assert %Scope{user: scoped_user} = socket.assigns.scope
      assert scoped_user.id == user.id
    end

    test "halts and redirects to login without a session" do
      assert {:halt, socket} = AssignScope.on_mount(:default, %{}, %{}, socket())

      assert socket.redirected == {:redirect, %{to: "/#/login", status: 302}}
    end

    test "halts and redirects to login when the user no longer exists" do
      user = insert(:user)
      Client.Repo.delete!(user)

      assert {:halt, socket} =
               AssignScope.on_mount(:default, %{}, %{"user_id" => user.id}, socket())

      assert socket.redirected == {:redirect, %{to: "/#/login", status: 302}}
    end
  end

  describe "router wiring" do
    test "every routed LiveView mounts the hook" do
      for route <- live_routes() do
        assert AssignScope in on_mounts(route),
               "#{route.path} is a routed LiveView with no scope hook. " <>
                 "Put it in a live_session with on_mount: ClientWeb.Live.AssignScope."
      end
    end

    test "a routed LiveView receives a scope", %{conn: conn} do
      user = insert(:user)
      log = insert(:food_log, owner_id: user.id)

      assert {:ok, _view, _html} = live(conn, ~p"/food-logs/#{log.id}?as=#{user.id}")
    end
  end

  # The dashboard is guarded by basic auth rather than by a user, so it has no
  # scope to build and is deliberately left out.
  defp live_routes do
    ClientWeb.Router.__routes__()
    |> Enum.filter(& &1.metadata[:phoenix_live_view])
    |> Enum.reject(&String.starts_with?(&1.path, "/admin/"))
  end

  defp on_mounts(route) do
    {_view, _action, _opts, extra} = route.metadata[:phoenix_live_view]

    extra
    |> get_in([:extra, :on_mount])
    |> List.wrap()
    |> Enum.map(fn %{id: {module, _stage}} -> module end)
  end

  defp socket, do: %Phoenix.LiveView.Socket{}
end
