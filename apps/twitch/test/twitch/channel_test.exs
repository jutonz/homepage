defmodule Twitch.ChannelTest do
  use Twitch.DataCase, async: true
  alias Twitch.Channel

  test "#get_by_user_id returns a channel if it exists" do
    channel_name = "best_channel"
    channel = insert(:channel, name: "#" <> channel_name)
    user = channel.user

    {:ok, actual} = Channel.get_by_user_id(user.id, channel_name)

    assert actual.id == channel.id
  end

  test "#get_by_user_id returns an error tuple if the channel does not exist" do
    user = insert(:user)
    channel_name = "does_not_exist"

    {:error, "No matching channel"} = Channel.get_by_user_id(user.id, channel_name)
  end

  test "#get_by_user_id doesn't let me get someone else's channel" do
    me = insert(:user)
    someone_else = insert(:user)
    channel_name = "not_my_channel"
    _not_my_channel = insert(:channel, user: someone_else, name: "#" <> channel_name)

    {:error, "No matching channel"} = Channel.get_by_user_id(me.id, channel_name)
  end
end
