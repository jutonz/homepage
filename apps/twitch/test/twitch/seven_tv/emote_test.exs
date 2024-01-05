defmodule Twitch.SevenTv.EmoteTest do
  use Twitch.DataCase, async: true
  alias Twitch.Factory
  alias Twitch.SevenTv.Emote

  describe "from_json/1" do
    test "converts the json to a struct" do
      json = %{
        "id" => "id",
        "name" => "name"
      }

      result = Emote.from_json(json)

      assert result.id == json["id"]
      assert result.name == json["name"]
    end

    test "converts the name into a regex" do
      json = %{"name" => "name"}

      regex = Emote.from_json(json).regex

      assert Regex.match?(regex, "name")
    end
  end

  describe "detect/2" do
    test "returns the number of matches in the string" do
      emote = Factory.build(:seven_tv_emote, regex: ~r/test/)
      chat_str = "test hello test"

      assert Emote.detect(emote, chat_str) == 2
    end

    test "says if the emote has no matches" do
      emote = Factory.build(:seven_tv_emote, regex: ~r/test/)
      assert Emote.detect(emote, "") == 0
    end
  end

  describe "detect_many/2" do
    test "returns a map of emote matches" do
      emote1 = Factory.build(:seven_tv_emote, name: "test1", regex: ~r/test1/)
      emote2 = Factory.build(:seven_tv_emote, name: "test2", regex: ~r/test2/)
      chat_str = "test1 test2 test2"

      result = Emote.detect_many([emote1, emote2], chat_str)

      assert %{
               "test1" => 1,
               "test2" => 2
             } = result
    end
  end
end
