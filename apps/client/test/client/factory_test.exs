defmodule Client.FactoryTest do
  use Client.DataCase, async: true
  alias Client.Scope

  test "build(:scope, user: user) scopes to the given user" do
    user = insert(:user)

    assert %Scope{user: ^user} = build(:scope, user: user)
  end

  test "build(:scope) scopes to a persisted user of its own" do
    assert %Scope{user: user} = build(:scope)
    assert Repo.get(Client.User, user.id)
  end
end
