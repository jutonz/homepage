defmodule Twitch.BttvTest do
  use Twitch.DataCase, async: true
  alias Twitch.Bttv

  describe "channel_ffz_emotes" do
    @good_channel_id "good-channel-id"
    @bad_channel_id "bad-channel-id"

    test "returns emotes given a channel id" do
      emotes = Bttv.channel_ffz_emotes(@good_channel_id)
      assert [%Twitch.Bttv.Emote{}] = emotes
    end

    test "returns an empty array for channels without ffz" do
      assert Bttv.channel_ffz_emotes(@bad_channel_id) == []
    end
  end
end
