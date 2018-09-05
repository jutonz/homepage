defmodule Twitch.TwitchEventTest do
  use ExUnit.Case
  alias Twitch.TwitchEvent

  test "#parse extracts room_id" do
    raw =
      "@badges=subscriber/3,premium/1;color=;display-name=pokuna;emotes=;id=fb27b3b6-5fcd-4828-a65f-37852502ba4c;mod=0;room-id=26301881;subscriber=1;tmi-sent-ts=1536110195916;turbo=0;user-id=126692015;user-type= :pokuna!pokuna@pokuna.tmi.twitch.tv PRIVMSG #sodapoppin :Wait why's dad not streaming? :sadpanda:\r\n"

    {:ok, parsed} = TwitchEvent.parse(raw, "#sodapoppin")
    IO.inspect(parsed)
    assert parsed.room_id == "26301881"
  end
end
