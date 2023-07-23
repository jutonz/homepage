defmodule ClientWeb.UserResolverTest do
  use ClientWeb.ConnCase, async: true
  alias Client.Factory

  describe "login" do
    test "returns the user and the JWT", %{conn: conn} do
      user = Factory.insert(:user, password: "password123")

      query = """
      mutation {
        login(email: "#{user.email}", password: "password123") {
          result {
            user { id email }
            jwt
          }
        }
      }
      """

      resp = conn |> post("/graphql", %{query: query}) |> json_response(200)

      result = get_in(resp, ~w[data login result])
      assert result["jwt"]
      assert get_in(result, ~w[user id]) == to_string(user.id)
      assert get_in(result, ~w[user email]) == user.email
    end

    test "returns an error if the password is invalid", %{conn: conn} do
      user = Factory.insert(:user, password: "password123")

      query = """
      mutation {
        login(email: "#{user.email}", password: "wrong") {
          result {
            user { id email }
            jwt
          }
          successful
          messages {
            message
          }
        }
      }
      """

      resp = conn |> post("/graphql", %{query: query}) |> json_response(200)

      refute get_in(resp, ~w[data successful])
      refute get_in(resp, ~w[data login result])
      assert [%{"message" => "Invalid email or password"}] = get_in(resp, ~w[data login messages])
    end

    test "returns an error if the user doesn't exist", %{conn: conn} do
      query = """
      mutation {
        login(email: "asdf", password: "asdf") {
          result {
            user { id email }
            jwt
          }
          successful
          messages {
            message
          }
        }
      }
      """

      resp = conn |> post("/graphql", %{query: query}) |> json_response(200)

      refute get_in(resp, ~w[data successful])
      refute get_in(resp, ~w[data login result])
      assert [%{"message" => "Invalid email or password"}] = get_in(resp, ~w[data login messages])
    end
  end
end
