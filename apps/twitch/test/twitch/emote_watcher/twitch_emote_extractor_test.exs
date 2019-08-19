defmodule Twitch.EmoteWatcher.TwitchEmoteExtractorTest do
  use Twitch.DataCase, async: true
  alias Twitch.EmoteWatcher.TwitchEmoteExtractor

  describe "extract/1" do
    test "extracts emotes" do
      event = build(:parsed_event)
      assert [%Twitch.Emote{}] = TwitchEmoteExtractor.extract(event)
    end

    test "returns an empty list when there are no tags" do
      event = build(:parsed_event, tags: nil)
      assert TwitchEmoteExtractor.extract(event) == []
    end

    test "returns an empty list when emotes is an empty string" do
      event = build(:parsed_event, tags: %{"emotes" => ""})
      assert TwitchEmoteExtractor.extract(event) == []
    end

    test "doesn't include emotes for which TwitchEmotes returns nothing" do
      event = build(:parsed_event, tags: %{"emotes" => "bad-id"})
      assert TwitchEmoteExtractor.extract(event) == []
    end
  end
end
