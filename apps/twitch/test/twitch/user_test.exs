defmodule Twitch.UserTest do
  use Twitch.DataCase, async: true
  alias Twitch.{GoogleRepo, Channel}

  test "deletes channel associations on destroy" do
    channel = insert(:channel)
    user = channel.user

    {:ok, _} = GoogleRepo.delete(user)

    assert GoogleRepo.get(Channel, channel.id) == nil
  end
end
