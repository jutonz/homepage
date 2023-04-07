defmodule ClientWeb.SessionResolverTest do
  use ClientWeb.ConnCase, async: true
  alias Client.TestUtils

  describe "current_user" do
    test "returns null if the user isn't logged in", %{conn: conn} do
      query = "{ getCurrentUser { id } }"

      res = conn |> post("/graphql", %{query: query}) |> json_response(200)

      %{"data" => %{"getCurrentUser" => current_user}} = res
      assert is_nil(current_user)
    end

    test "returns the user if the user is logged in", %{conn: conn} do
      conn = conn |> TestUtils.setup_current_user()
      query = "{ getCurrentUser { id } }"

      res = conn |> post("/graphql", %{query: query}) |> json_response(200)

      %{"data" => %{"getCurrentUser" => current_user}} = res
      refute is_nil(current_user)
      assert current_user["id"]
    end
  end
end
