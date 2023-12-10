defmodule Twitch.EmoteWatcher.TwitchEmoteExtractorTest do
  use Twitch.DataCase, async: true
  alias Twitch.Factory
  alias Twitch.EmoteWatcher.TwitchEmoteExtractor

  describe "extract/1" do
    test "extracts one emote" do
      event = Factory.build(:parsed_event,
        message: "hello GoatEmotey blah󠀀",
        tags: %{
          "emotes" => "emotesv2_e41e4d6808224f25ae1fb625aa26de63:6-15",
        })

      assert [%Twitch.Emote{
        code: "GoatEmotey",
        id: "emotesv2_e41e4d6808224f25ae1fb625aa26de63"
      }] = TwitchEmoteExtractor.extract(event)
    end

    test "extracts multiple emote" do
      event = Factory.build(:parsed_event,
        message: "hello duDudu something HeyGuys",
        tags: %{
          "emotes" => "62834:6-11/30259:23-29"
        })

      assert [
        %Twitch.Emote{
          code: "HeyGuys",
          id: "30259"
        },
        %Twitch.Emote{
          code: "duDudu",
          id: "62834"
        }
      ] = TwitchEmoteExtractor.extract(event)
    end

    test "returns an empty list when there are no tags" do
      event = Factory.build(:parsed_event, tags: nil)
      assert TwitchEmoteExtractor.extract(event) == []
    end

    test "returns an empty list when tags is an empty map" do
      event = Factory.build(:parsed_event, tags: %{})
      assert TwitchEmoteExtractor.extract(event) == []
    end

    test "returns an empty list when emotes is an empty string" do
      event = Factory.build(:parsed_event, tags: %{"emotes" => ""})
      assert TwitchEmoteExtractor.extract(event) == []
    end

    test "returns an empty list when the emote list is malformed" do
      event = Factory.build(:parsed_event, tags: %{"emotes" => "invalid"})
      assert TwitchEmoteExtractor.extract(event) == []
    end
  end
end
