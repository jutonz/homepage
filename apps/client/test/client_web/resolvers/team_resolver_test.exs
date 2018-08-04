defmodule ClientWeb.TeamResolverTest do
  use ClientWeb.ConnCase, async: true
  alias Client.{TestUtils, Team, Repo, Session, User}

  describe "create_team" do
    test "can create an team", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()

      query = """
        mutation {
          createTeam(name: "hello") { name id }
        }
      """

      res = conn |> post("/graphql", %{query: query}) |> json_response(200)

      %{"data" => %{"createTeam" => %{"name" => name}}} = res
      assert name == "hello"
    end

    test "adds a user association for the current user", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()

      query = """
        mutation {
          createTeam(name: "hello") { name id }
        }
      """

      res = conn |> post("/graphql", %{query: query}) |> json_response(200)
      %{"data" => %{"createTeam" => %{"id" => id}}} = res

      team = Team |> Repo.get!(id) |> Repo.preload(:users)
      team_user = team.users |> hd
      {:ok, current_user} = conn |> Session.current_user()

      assert current_user.id == team_user.id
    end

    test "returns validation errors nicely", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()

      query = """
        mutation {
          createTeam(name: "hello") { name id }
        }
      """

      conn |> post("/graphql", %{query: query})

      # Trigger a validation error by attempting to duplicate an existing name
      error_message =
        with res <- conn |> post("/graphql", %{query: query}),
             json <- res |> json_response(200),
             first_error <- json["errors"] |> hd,
             do: first_error["message"]

      assert error_message == "Name has already been taken"
    end
  end

  describe "rename_team" do
    test "can rename an team", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()
      {:ok, user} = conn |> Session.current_user()

      {:ok, team} =
        %Team{name: "hello"}
        |> Team.changeset()
        |> Ecto.Changeset.put_assoc(:users, [user])
        |> Repo.insert()

      new_name = "#{team.name}_#{:rand.uniform()}"

      query = """
      mutation {
        renameTeam(id: #{team.id}, name: "#{new_name}") { name }
      }
      """

      json = conn |> post("/graphql", %{query: query}) |> json_response(200)
      %{"data" => %{"renameTeam" => %{"name" => actual}}} = json

      assert new_name === actual
    end
  end

  describe "get_team_users" do
    test "can get team users", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()
      {:ok, user} = conn |> Session.current_user()

      {:ok, team} =
        %Team{name: "hello"}
        |> Team.changeset()
        |> Ecto.Changeset.put_assoc(:users, [user])
        |> Repo.insert()

      query = """
      query {
        getTeamUsers(teamId: #{team.id}) { email }
      }
      """

      json = conn |> post("/graphql", %{query: query}) |> json_response(200)

      %{"data" => %{"getTeamUsers" => [%{"email" => actual}]}} = json

      assert user.email === actual
    end
  end

  describe "get_team_user" do
    test "returns a user of the team", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()
      {:ok, user} = conn |> Session.current_user()

      {:ok, team} =
        %Team{name: "hi"}
        |> Team.changeset()
        |> Ecto.Changeset.put_assoc(:users, [user])
        |> Repo.insert()

      query = """
      query {
        getTeamUser(teamId: #{team.id}, userId: #{user.id}) { email }
      }
      """

      json = conn |> post("/graphql", %{query: query}) |> json_response(200)
      %{"data" => %{"getTeamUser" => %{"email" => actual}}} = json

      assert user.email == actual
    end

    test "does not return a user if not on the team", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()
      {:ok, user} = conn |> Session.current_user()

      {:ok, team} =
        %Team{name: "hi"}
        |> Team.changeset()
        |> Repo.insert()

      query = """
      query {
        getTeamUser(teamId: #{team.id}, userId: #{user.id}) { email }
      }
      """

      json = conn |> post("/graphql", %{query: query}) |> json_response(200)

      %{"data" => %{"getTeamUser" => data}} = json

      assert data == nil
    end
  end

  describe "join_team" do
    test "it adds a user to an team", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()
      {:ok, user} = conn |> Session.current_user()

      {:ok, team_creator} =
        %User{}
        |> User.changeset(%{email: "wee@mail.com", password: "password123"})
        |> Repo.insert()

      {:ok, team} =
        %Team{}
        |> Team.changeset(%{name: "hi"})
        |> Ecto.Changeset.put_assoc(:users, [team_creator])
        |> Repo.insert()

      query = """
        mutation {
          joinTeam(name: "#{team.name}") { name id }
        }
      """

      json = conn |> post("/graphql", %{query: query}) |> json_response(200)
      %{"data" => %{"joinTeam" => %{"id" => id}}} = json
      db_team = Team |> Repo.get(id) |> Repo.preload(:users)

      assert db_team.users |> Enum.member?(user) == true
    end
  end

  describe "leave_team" do
    test "it removes a user from an team", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()
      {:ok, user} = conn |> Session.current_user()

      {:ok, team_creator} =
        %User{}
        |> User.changeset(%{email: "wee@mail.com", password: "password123"})
        |> Repo.insert()

      {:ok, team} =
        %Team{}
        |> Team.changeset(%{name: "hi"})
        |> Ecto.Changeset.put_assoc(:users, [team_creator, user])
        |> Repo.insert()

      query = """
        mutation {
          leaveTeam(id: "#{team.id}") { id }
        }
      """

      json = conn |> post("/graphql", %{query: query}) |> json_response(200)
      %{"data" => %{"leaveTeam" => %{"id" => id}}} = json
      db_team = Team |> Repo.get(id) |> Repo.preload(:users)

      assert db_team.users |> Enum.member?(user) == false
    end
  end
end
