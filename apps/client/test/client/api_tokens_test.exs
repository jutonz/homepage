defmodule Client.ApiTokensTest do
  use Client.DataCase, async: true
  alias Client.ApiTokens
  alias Client.ApiTokens.ApiToken

  describe "new_changeset/0" do
    test "creates a changeset" do
      assert %Ecto.Changeset{} = ApiTokens.new_changeset()
    end
  end

  describe "get/1" do
    test "returns a token" do
      token_id = insert(:api_token).id
      assert %ApiToken{id: token_id} = ApiTokens.get(token_id)
    end
  end

  describe "get_by_description/1" do
    test "returns a token" do
      token = insert(:api_token)
      desc = token.description
      user_id = token.user_id

      actual = ApiTokens.get_by_description(user_id, desc)

      assert %ApiToken{description: desc} = actual
    end
  end

  describe "list/1" do
    test "returns all tokens for a user" do
      user = insert(:user)
      tokens = insert_pair(:api_token, user_id: user.id)

      actual = ApiTokens.list(user.id)

      assert Enum.at(tokens, 0) in actual
      assert Enum.at(tokens, 1) in actual
    end
  end

  describe "create/1" do
    test "creates a token" do
      params = params_for(:api_token)

      assert {:ok, %ApiToken{}} = ApiTokens.create(params)
    end
  end

  describe "delete/1" do
    test "deletes a token" do
      token_id = insert(:api_token).id

      assert {:ok, %ApiToken{}} = ApiTokens.delete(token_id)
    end
  end
end
