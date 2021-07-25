defmodule ClientWeb.Storage.ContextControllerTest do
  use ClientWeb.ConnCase, async: true

  alias Client.{
    Storage,
    Repo
  }

  describe "create/2" do
    test "creates a context with a team", %{conn: conn} do
      user = insert(:user)
      attrs = string_params_for(:storage_context, creator: user)

      team_names =
        :team
        |> insert_pair(users: [user])
        |> Enum.map(& &1.name)

      attrs = Map.put(attrs, "team_names", Enum.join(team_names, ", "))
      params = %{as: user.id, context: attrs}

      conn = post(conn, Routes.storage_context_path(conn, :create, params))

      [context] =
        user.id
        |> Storage.list_contexts()
        |> Repo.preload(:teams)

      assert Enum.map(context.teams, & &1.name) == team_names
    end
  end

  describe "update/2" do
    test "updates a context with teams", %{conn: conn} do
      user = insert(:user)
      context = insert(:storage_context, creator: user)
      [team1, team2] = insert_pair(:team, users: [user])

      params = %{
        "as" => user.id,
        "id" => context.id,
        "context" => %{"team_names" => "#{team1.name}, #{team2.name}"}
      }

      conn = patch(conn, Routes.storage_context_path(conn, :update, context, params))

      assert redirected_to(conn) == Routes.storage_context_path(conn, :show, context)

      context = user.id |> Storage.get_context(context.id) |> Repo.preload(:teams)
      actual_team_names = Enum.map(context.teams, & &1.name)
      assert team1.name in actual_team_names
      assert team2.name in actual_team_names
    end
  end
end
