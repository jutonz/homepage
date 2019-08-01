defmodule Twitch.TwitchEmotesTest do
  use Twitch.DataCase, async: true
  alias Twitch.TwitchEmotes

  describe "emote/1" do
    test "returns an emote" do
      assert %Twitch.Emote{id: 25} = TwitchEmotes.emote(25)
    end

    test "returns an empty list for an emote that doesn't exist" do
      assert nil == TwitchEmotes.emote("bad-id")
    end
  end

  describe "emotes/1" do
    test "returns a list of emotes" do
      assert [%Twitch.Emote{id: 25}] = TwitchEmotes.emotes([25])
    end
  end
end
