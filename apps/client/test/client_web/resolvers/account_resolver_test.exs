defmodule ClientWeb.AccountResolverTest do
  use ClientWeb.ConnCase
  alias Client.{TestUtils, Account, Repo, SessionServer, User}

  describe "create_account" do
    test "can create an account", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()

      query = """
        mutation {
          createAccount(name: "hello") { name id }
        }
      """

      res = conn |> post("/graphql", %{query: query}) |> json_response(200)

      %{"data" => %{"createAccount" => %{"name" => name}}} = res
      assert name == "hello"
    end

    test "adds a user association for the current user", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()

      query = """
        mutation {
          createAccount(name: "hello") { name id }
        }
      """

      res = conn |> post("/graphql", %{query: query}) |> json_response(200)
      %{"data" => %{"createAccount" => %{"id" => id}}} = res

      account = Account |> Repo.get!(id) |> Repo.preload(:users)
      account_user = account.users |> hd
      {:ok, current_user} = conn |> SessionServer.current_user()

      assert current_user.id == account_user.id
    end

    test "returns validation errors nicely", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()

      query = """
        mutation {
          createAccount(name: "hello") { name id }
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

  describe "rename_account" do
    test "can rename an account", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()
      {:ok, user} = conn |> SessionServer.current_user()

      {:ok, account} =
        %Account{name: "hello"} |> Account.changeset() |> Ecto.Changeset.put_assoc(:users, [user])
        |> Repo.insert()

      new_name = "#{account.name}_#{:rand.uniform()}"

      query = """
      mutation {
        renameAccount(id: #{account.id}, name: "#{new_name}") { name }
      }
      """

      json = conn |> post("/graphql", %{query: query}) |> json_response(200)
      %{"data" => %{"renameAccount" => %{"name" => actual}}} = json

      assert new_name === actual
    end
  end

  describe "get_account_users" do
    test "can get account users", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()
      {:ok, user} = conn |> SessionServer.current_user()

      {:ok, account} =
        %Account{name: "hello"} |> Account.changeset() |> Ecto.Changeset.put_assoc(:users, [user])
        |> Repo.insert()

      query = """
      query {
        getAccountUsers(id: #{account.id}) { email }
      }
      """

      json = conn |> post("/graphql", %{query: query}) |> json_response(200)

      %{"data" => %{"getAccountUsers" => [%{"email" => actual}]}} = json

      assert user.email === actual
    end
  end

  describe "get_account_user" do
    test "returns a user of the account", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()
      {:ok, user} = conn |> SessionServer.current_user()

      {:ok, account} =
        %Account{name: "hi"}
        |> Account.changeset()
        |> Ecto.Changeset.put_assoc(:users, [user])
        |> Repo.insert()

      query = """
      query {
        getAccountUser(accountId: #{account.id}, userId: #{user.id}) { email }
      }
      """

      json = conn |> post("/graphql", %{query: query}) |> json_response(200)
      %{"data" => %{"getAccountUser" => %{"email" => actual}}} = json

      assert user.email == actual
    end

    test "does not return a user if not on the account", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()
      {:ok, user} = conn |> SessionServer.current_user()

      {:ok, account} =
        %Account{name: "hi"}
        |> Account.changeset()
        |> Repo.insert()

      query = """
      query {
        getAccountUser(accountId: #{account.id}, userId: #{user.id}) { email }
      }
      """

      json = conn |> post("/graphql", %{query: query}) |> json_response(200)

      %{"data" => %{"getAccountUser" => data}} = json

      assert data == nil
    end
  end

  describe "join_account" do
    test "it adds a user to an account", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()
      {:ok, user} = conn |> SessionServer.current_user()

      {:ok, account_creator} =
        %User{}
        |> User.changeset(%{email: "wee@mail.com", password: "password123"})
        |> Repo.insert()

      {:ok, account} =
        %Account{}
        |> Account.changeset(%{name: "hi"})
        |> Ecto.Changeset.put_assoc(:users, [account_creator])
        |> Repo.insert()

      query = """
        mutation {
          joinAccount(name: "#{account.name}") { name id }
        }
      """

      json = conn |> post("/graphql", %{query: query}) |> json_response(200)
      %{"data" => %{"joinAccount" => %{"id" => id}}} = json
      db_account = Account |> Repo.get(id) |> Repo.preload(:users)

      assert db_account.users |> Enum.member?(user) == true
    end
  end
end
