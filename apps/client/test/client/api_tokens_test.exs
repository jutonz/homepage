defmodule Client.ApiTokensTest do
  use Client.DataCase, async: true

  alias Client.ApiTokens
  alias Client.ApiTokens.ApiToken

  setup do
    scope = build(:scope)
    %{scope: scope, token: insert(:api_token, user_id: scope.user.id)}
  end

  describe "new_changeset/0" do
    test "returns an empty changeset" do
      cs = ApiTokens.new_changeset()

      assert %Ecto.Changeset{} = cs
      assert cs.data == %ApiToken{}
    end
  end

  describe "list/1" do
    test "returns the scope's tokens", %{scope: scope, token: token} do
      _other_token = insert(:api_token)

      assert Enum.map(ApiTokens.list(scope), & &1.id) == [token.id]
    end
  end

  describe "get/2" do
    test "returns the scope's token", %{scope: scope, token: token} do
      token_id = token.id

      assert %ApiToken{id: ^token_id} = ApiTokens.get(scope, token_id)
    end

    test "is nil for another user's token", %{scope: scope} do
      other_token = insert(:api_token)

      assert ApiTokens.get(scope, other_token.id) == nil
    end

    test "is nil when the token doesn't exist", %{scope: scope} do
      assert ApiTokens.get(scope, Ecto.UUID.generate()) == nil
    end
  end

  describe "get!/2" do
    test "returns the scope's token", %{scope: scope, token: token} do
      token_id = token.id

      assert %ApiToken{id: ^token_id} = ApiTokens.get!(scope, token_id)
    end

    test "raises for another user's token", %{scope: scope} do
      other_token = insert(:api_token)

      assert_raise Ecto.NoResultsError, fn ->
        ApiTokens.get!(scope, other_token.id)
      end
    end
  end

  describe "get_by_description/2" do
    test "returns the scope's token", %{scope: scope, token: token} do
      description = token.description

      assert %ApiToken{description: ^description} =
               ApiTokens.get_by_description(scope, description)
    end

    test "is nil for another user's token", %{scope: scope} do
      other_token = insert(:api_token)

      assert ApiTokens.get_by_description(scope, other_token.description) == nil
    end
  end

  describe "create/2" do
    test "creates a token owned by the scope", %{scope: scope} do
      assert {:ok, token} = ApiTokens.create(scope, %{"description" => "laptop"})
      assert token.description == "laptop"
      assert token.user_id == scope.user.id
      assert token.token
    end

    test "takes the owner from the scope, not the params", %{scope: scope} do
      other = insert(:user)

      assert {:ok, token} =
               ApiTokens.create(scope, %{"description" => "laptop", "user_id" => other.id})

      assert token.user_id == scope.user.id
    end

    test "generates the token value rather than taking it from the params", %{scope: scope} do
      stolen = insert(:api_token)

      assert {:ok, token} =
               ApiTokens.create(scope, %{"description" => "laptop", "token" => stolen.token})

      refute token.token == stolen.token
    end

    test "returns the changeset when the description is taken", %{scope: scope, token: token} do
      assert {:error, %Ecto.Changeset{}} =
               ApiTokens.create(scope, %{"description" => token.description})
    end
  end

  describe "delete/2" do
    test "deletes the scope's token", %{scope: scope, token: token} do
      assert {:ok, %ApiToken{}} = ApiTokens.delete(scope, token.id)
      refute Repo.get(ApiToken, token.id)
    end

    test "raises for another user's token, leaving it intact", %{scope: scope} do
      other_token = insert(:api_token)

      assert_raise Ecto.NoResultsError, fn ->
        ApiTokens.delete(scope, other_token.id)
      end

      assert Repo.get(ApiToken, other_token.id)
    end
  end
end
