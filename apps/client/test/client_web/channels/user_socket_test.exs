defmodule ClientWeb.UserSocketTest do
  use ClientWeb.ChannelCase, async: true
  import Client.Factory
  alias Client.Scope
  alias ClientWeb.UserSocket

  test "assigns a scope for the token's user" do
    api_token = insert(:api_token)

    assert {:ok, socket} = connect(UserSocket, %{"token" => api_token.token})
    assert %Scope{user: user} = socket.assigns.scope
    assert user.id == api_token.user_id
  end

  test "refuses a token whose user no longer exists" do
    api_token = insert(:api_token)
    Client.User |> Client.Repo.get!(api_token.user_id) |> Client.Repo.delete!()

    assert :error = connect(UserSocket, %{"token" => api_token.token})
  end

  test "refuses an unknown token" do
    assert :error = connect(UserSocket, %{"token" => "nope"})
  end
end
