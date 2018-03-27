defmodule ClientWeb.AccountResolverTest do
  use ClientWeb.ConnCase
  alias Client.{TestUtils,Account,Repo,SessionServer}

  describe "create_account" do
    test "can create an account", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user

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
      conn = conn |> TestUtils.setup_current_user

      query = """
        mutation {
          createAccount(name: "hello") { name id }
        }
      """

      res = conn |> post("/graphql", %{query: query}) |> json_response(200)
      %{"data" => %{"createAccount" => %{"id" => id}}} = res

      account = Account |> Repo.get!(id) |> Repo.preload(:users)
      account_user = account.users |> hd
      {:ok, current_user } = conn |> SessionServer.current_user

      assert current_user.id == account_user.id
    end

    test "returns validation errors nicely", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user

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
      conn = conn |> TestUtils.setup_current_user
      {:ok, user} = conn |> SessionServer.current_user()

      {:ok, account} = %Account{name: "hello"} |> Account.changeset |> Ecto.Changeset.put_assoc(:users, [user]) |> Repo.insert
      new_name = "#{account.name}_#{:rand.uniform()}"

      query = """
      mutation {
        renameAccount(id: #{account.id}, name: "#{new_name}") { name }
      }
      """

      json = conn |> post("/graphql", %{query: query}) |> json_response(200)
      %{"data" => %{"renameAccount" => %{ "name" => actual}}} = json

      assert new_name === actual
    end
  end
end
