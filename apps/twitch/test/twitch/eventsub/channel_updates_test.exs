defmodule Twitch.Eventsub.ChannelUpdatesTest do
  use Twitch.DataCase, async: true

  alias Twitch.{
    Eventsub.ChannelUpdates,
    Factory
  }

  describe ".list_by_user_id/1" do
    test "returns updates for the given user id" do
      update = Factory.insert(:twitch_channel_update, twitch_user_id: "me")
      Factory.insert(:twitch_channel_update, twitch_user_id: "notme")

      [actual] = ChannelUpdates.list_by_user_id("me")

      assert actual.id == update.id
    end
  end
end
