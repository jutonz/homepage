defmodule Twitch.UserTest do
  use Twitch.DataCase, async: true
  alias Twitch.{Repo, Channel}

  test "deletes channel associations on destroy" do
    channel = insert(:channel)
    user = channel.user

    {:ok, _} = Repo.delete(user)

    assert Repo.get(Channel, channel.id) == nil
  end
end
