defmodule Twitch.ParsedEventTest do
  use ExUnit.Case, async: true
  alias Twitch.ParsedEvent

  test "#from_raw can parse PRIVMSG" do
    raw = ":syps_!syps_@syps_.tmi.twitch.tv PRIVMSG #comradenerdy :TaBeRu\r\n"
    {:ok, parsed} = ParsedEvent.from_raw(raw)
    assert parsed.message == "TaBeRu"
  end

  test "#from_raw can parse pings" do
    raw = "PING :tmi.twitch.tv\r\n"
    {:ok, parsed} = ParsedEvent.from_raw(raw)
    assert parsed.irc_command == "PING"
  end

  test "#from_raw can handle unicode" do
    raw = ":funkycal08!funkycal08@funkycal08.tmi.twitch.tv PRIVMSG #elajjaz :乇乂ㄒ尺卂 ㄒ卄丨匚匚\r\n"
    {:ok, parsed} = ParsedEvent.from_raw(raw)
    assert parsed.message == "乇乂ㄒ尺卂 ㄒ卄丨匚匚"
  end

  test "#from_raw can parse PRIVMSG with ACTION prefix" do
    # raw = ":takeitbot!takeitbot@takeitbot.tmi.twitch.tv PRIVMSG #comradenerdy :ACTION husky_potato lost 300 blyats in roulette and now has 1656 blyats! FeelsBadMan"
    raw =
      ":takeitbot!takeitbot@takeitbot.tmi.twitch.tv PRIVMSG #comradenerdy :ACTION GoAkke went all in and lost every single one of their 215 blyats LUL"

    {:ok, parsed} = ParsedEvent.from_raw(raw)

    assert parsed.message ==
             "ACTION GoAkke went all in and lost every single one of their 215 blyats LUL"
  end
end
