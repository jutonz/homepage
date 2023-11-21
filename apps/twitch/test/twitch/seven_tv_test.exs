defmodule Twitch.SevenTvTest do
  use Twitch.DataCase, async: true
  alias Twitch.SevenTv

  describe "channel_emotes/1" do
    test "returns a list of emotes" do
      emotes = SevenTv.channel_emotes("good-channel-id")

      [emote1, emote2] = emotes
      assert emote1.name == "Okayeg"
      assert emote2.name == "FeelsRainMan"
    end
  end
end
