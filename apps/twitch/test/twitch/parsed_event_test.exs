defmodule Twitch.ParsedEventTest do
  use ExUnit.Case, async: true
  alias Twitch.ParsedEvent

  describe "#parse_tags" do
    test "is nil if passed nil" do
      assert ParsedEvent.parse_tags(nil) == %{}
    end

    test "returns a map of tags" do
      raw = "@badge-info=;badges=;color=#DAA520;display-name=gagin5;emotes=;flags=;id=d5ae0ce5-bb7e-4785-9a22-1bb6fb89cbdc;mod=0;room-id=26921830;subscriber=0;tmi-sent-ts=1564421499357;turbo=0;user-id=238338567;user-type="

      parsed = ParsedEvent.parse_tags(raw)

      assert parsed["color"] == "#DAA520"
      assert parsed["user-id"] == "238338567"
    end
  end

  test "#from_raw can pull out twitch tags" do
    raw = ~s[@badge-info=;badges=;color=#DAA520;display-name=gagin5;emotes=;flags=;id=d5ae0ce5-bb7e-4785-9a22-1bb6fb89cbdc;mod=0;room-id=26921830;subscriber=0;tmi-sent-ts=1564421499357;turbo=0;user-id=238338567;user-type= :gagin5!gagin5@gagin5.tmi.twitch.tv PRIVMSG #elajjaz :@odduneven U are from russia?]

    {:ok, parsed} = ParsedEvent.from_raw(raw)

    assert parsed.tags["user-id"] == "238338567"
  end

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
    raw =
      ":takeitbot!takeitbot@takeitbot.tmi.twitch.tv PRIVMSG #comradenerdy :ACTION Lyovknight won 200 blyats in roulette and now has 16095 blyats! FeelsGoodMan"

    {:ok, parsed} = ParsedEvent.from_raw(raw)

    assert parsed.message ==
             "ACTION Lyovknight won 200 blyats in roulette and now has 16095 blyats! FeelsGoodMan"
  end

  test "#from_raw parses ACTION escaped with \u0001" do
    raw =
      ":stay_hydrated_bot!stay_hydrated_bot@stay_hydrated_bot.tmi.twitch.tv PRIVMSG #comradenerdy :\u0001ACTION @comradenerdy stayhyBottle You've been live for just over 8 hours. By this point in your broadcast you should have consumed at least 32oz (960mL) of water to maintain optimum hydration.\u0001"

    {:ok, parsed} = ParsedEvent.from_raw(raw)

    assert parsed.irc_command == "ACTION"
    assert parsed.channel == "#comradenerdy"

    assert parsed.message ==
             "@comradenerdy stayhyBottle You've been live for just over 8 hours. By this point in your broadcast you should have consumed at least 32oz (960mL) of water to maintain optimum hydration."
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

  test "#from_raw can handle CAP * ACK" do
    raw = ":tmi.twitch.tv CAP * ACK :twitch.tv/commands twitch.tv/membership"

    {:ok, parsed} = ParsedEvent.from_raw(raw)

    assert parsed.irc_command == "CAP"
    assert parsed.message == "twitch.tv/commands twitch.tv/membership"
    assert parsed.channel == nil
    assert parsed.display_name == nil
  end
end
