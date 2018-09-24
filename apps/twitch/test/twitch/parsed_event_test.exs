defmodule Twitch.ParsedEventTest do
  use ExUnit.Case, async: true
  alias Twitch.ParsedEvent

  test "#from_raw can parse PRIVMSG" do
    raw = ":syps_!syps_@syps_.tmi.twitch.tv PRIVMSG #comradenerdy :TaBeRu"
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

  test "#from_raw can parse CLEARCHAT" do
    raw = ":tmi.twitch.tv CLEARCHAT #twitchpresents :spookyboogie27\r\n"

    {:ok, parsed} = ParsedEvent.from_raw(raw)

    assert parsed.irc_command == "CLEARCHAT"
    assert parsed.channel == "#twitchpresents"
    assert parsed.message == "spookyboogie27"
  end

  test "#from_raw can parse PART" do
    raw =
      ":stay_hydrated_bot!stay_hydrated_bot@stay_hydrated_bot.tmi.twitch.tv PART #themunchdown\r\n"

    {:ok, parsed} = ParsedEvent.from_raw(raw)

    assert parsed.irc_command == "PART"
    assert parsed.display_name == "stay_hydrated_bot"
    assert parsed.channel == "#themunchdown"
    assert parsed.raw_event == raw
  end

  test "#from_raw can parse JOIN" do
    raw = ":lord0pichacufon!lord0pichacufon@lord0pichacufon.tmi.twitch.tv JOIN #themunchdown\r\n"

    {:ok, parsed} = ParsedEvent.from_raw(raw)

    assert parsed.irc_command == "JOIN"
    assert parsed.display_name == "lord0pichacufon"
    assert parsed.raw_event == raw
  end

  test "#from_raw can parse HOSTTARGET" do
    raw = ":tmi.twitch.tv HOSTTARGET #admiralbahroo :woops -\r\n"

    {:ok, parsed} = ParsedEvent.from_raw(raw)

    assert parsed.irc_command == "HOSTTARGET"
    assert parsed.channel == "#admiralbahroo"
    assert parsed.message == "woops"
  end

  test "#from_raw can parse USERNOTICE" do
    raw =
      ":tmi.twitch.tv USERNOTICE #admiralbahroo :31 motnhs, sorry for not coming round much anymore, enjoy my money\r\n"

    {:ok, parsed} = ParsedEvent.from_raw(raw)

    assert parsed.irc_command == "USERNOTICE"
    assert parsed.raw_event == raw
    assert parsed.channel == "#admiralbahroo"
    assert parsed.message == "31 motnhs, sorry for not coming round much anymore, enjoy my money"
  end

  test "#from_raw can parse MODE" do
    raw = ":jtv MODE #spartyon7 -o britnoth"

    {:ok, parsed} = ParsedEvent.from_raw(raw)

    assert parsed.irc_command == "MODE"
    assert parsed.message == "-o britnoth"
    assert parsed.channel == "#spartyon7"
    assert parsed.display_name == "jtv"
  end

  test "#from_raw can handle a NAMES list" do
    raw = ":syps_.tmi.twitch.tv 353 syps_ = #naro :crosstaker yuiyuigahama"

    {:ok, parsed} = ParsedEvent.from_raw(raw)

    assert parsed.irc_command == "353"
    assert parsed.message == "crosstaker yuiyuigahama"
    assert parsed.channel == "#naro"
    assert parsed.display_name == "syps_"
  end

  test "#from_raw can handle GLOBALUSERSTATE" do
    raw = ":tmi.twitch.tv GLOBALUSERSTATE"

    {:ok, parsed} = ParsedEvent.from_raw(raw)

    assert parsed.irc_command == "GLOBALUSERSTATE"
    assert parsed.message == nil
    assert parsed.channel == nil
    assert parsed.display_name == nil
  end
end
