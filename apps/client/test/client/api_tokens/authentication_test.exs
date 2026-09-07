defmodule Client.ApiTokens.AuthenticationTest do
  use Client.DataCase, async: true

  alias Client.ApiTokens.ApiToken
  alias Client.ApiTokens.Authentication
  alias Client.Scope

  describe "authenticate/1" do
    test "returns the token and a scope for its user" do
      api_token = insert(:api_token)
      token_id = api_token.id
      user_id = api_token.user_id

      assert {:ok, %ApiToken{id: ^token_id}, %Scope{user: user}} =
               Authentication.authenticate(api_token.token)

      assert user.id == user_id
    end

    test "is an error for an unknown token value" do
      assert Authentication.authenticate(ApiToken.gen_token()) == :error
    end

    test "is an error when the token's user has been deleted" do
      api_token = insert(:api_token)
      Client.User |> Repo.get!(api_token.user_id) |> Repo.delete!()

      assert Authentication.authenticate(api_token.token) == :error
    end

    test "is an error for a value that is not a token string" do
      assert Authentication.authenticate(nil) == :error
    end
  end
end
