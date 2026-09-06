defmodule Client.ScopeTest do
  use Client.DataCase, async: true
  alias Client.Scope

  describe "for_user/1" do
    test "carries the given user" do
      user = insert(:user)

      assert %Scope{user: ^user} = Scope.for_user(user)
    end
  end

  describe "for_user_id/1" do
    test "loads the user" do
      user = insert(:user)

      assert %Scope{user: loaded} = Scope.for_user_id(user.id)
      assert loaded.id == user.id
    end

    test "is nil when the user no longer exists" do
      user = insert(:user)
      Repo.delete!(user)

      assert Scope.for_user_id(user.id) == nil
    end

    test "is nil without a user id" do
      assert Scope.for_user_id(nil) == nil
    end
  end
end
