defmodule Twitch.Bttv.EmoteTest do
  use Twitch.DataCase, async: true
  alias Twitch.Bttv

  test "from_bttv_json/1 converts a map into a struct" do
    json = %{
      "code" => "code",
      "id" => "123",
      "imageType" => "gif"
    }

    result = Bttv.Emote.from_bttv_json(json)

    assert result.code == "code"
    assert result.id == "123"
    assert result.image_type == "gif"
    assert Regex.source(result.regex) == "code"
  end

  test "detect/2 is 0 if the string does not contain the emote" do
    emote = build(:emote, code: "pepeL")
    message = "hey everyone nrdyPrivet"

    assert Bttv.Emote.detect(emote, message) == 0
  end

  test "detect/2 is 1 if the string contains the emote once" do
    emote = build(:emote, code: "pepeL", regex: ~r/pepeL/)
    message = "hey everyone pepeL"

    assert Bttv.Emote.detect(emote, message) == 1
  end

  test "detect/2 is 2 if the string contains the emote twice" do
    emote = build(:emote, code: "kumaPls", regex: ~r/kumaPls/)
    message = "kumaPls ela13 kumaPls"

    assert Bttv.Emote.detect(emote, message) == 2
  end

  test "detect_many/2 returns a map with detected emotes" do
    emotes = [
      build(:emote, code: "kumaPls", regex: ~r/kumaPls/),
      build(:emote, code: "ela13", regex: ~r/ela13/)
    ]

    message = "kumaPls ela13 kumaPls AYAYA"

    expected = %{
      "ela13" => 1,
      "kumaPls" => 2
    }

    assert Bttv.Emote.detect_many(emotes, message) == expected
  end

  test "detect_many/2 omits emotes which weren't detected" do
    emotes = [
      build(:emote, code: "kumaPls", regex: ~r/kumaPls/),
      build(:emote, code: "ela13", regex: ~r/ela13/)
    ]

    message = "kumaPls kumaPls"

    expected = %{
      "kumaPls" => 2
    }

    assert Bttv.Emote.detect_many(emotes, message) == expected
  end
end
