defmodule Twitch.TwitchEventTest do
  use ExUnit.Case, async: true
  alias Twitch.TwitchEvent

  #test "#parse extracts room_id" do
    #raw =
      #"@badges=subscriber/3,premium/1;color=;display-name=pokuna;emotes=;id=fb27b3b6-5fcd-4828-a65f-37852502ba4c;mod=0;room-id=26301881;subscriber=1;tmi-sent-ts=1536110195916;turbo=0;user-id=126692015;user-type= :pokuna!pokuna@pokuna.tmi.twitch.tv PRIVMSG #sodapoppin :Wait why's dad not streaming? :sadpanda:\r\n"
    #raw =
      #":pokuna!pokuna@pokuna.tmi.twitch.tv PRIVMSG #sodapoppin :Wait why's dad not streaming? :sadpanda:\r\n"

    #{:ok, parsed} = TwitchEvent.parse(raw)
    #assert parsed.room_id == "26301881"
  #end

  #test "#parse extracts emotes" do
    #raw = "@badges=moderator/1;color=;display-name=TakeItBot;emotes=88:38-45;id=d0a02b14-2b28-4bb3-8b20-9dc3aa3f907d;mod=1;room-id=61350245;subscriber=0;tmi-sent-ts=1536156357557;turbo=0;user-id=253457704;user-type=mod :takeitbot!takeitbot@takeitbot.tmi.twitch.tv PRIVMSG #comradenerdy :Dr_Jan_Itor gave 1300 blyats to kif17 PogChamp\r\n"
    #raw = ":takeitbot!takeitbot@takeitbot.tmi.twitch.tv PRIVMSG #comradenerdy :Dr_Jan_Itor gave 1300 blyats to kif17 PogChamp\r\n"
    #{:ok, parsed} = TwitchEvent.parse(raw)
    #assert parsed.emotes == "88:38-45"
  #end

  test "#parse can parse PRIVMSG" do
    raw = ":syps_!syps_@syps_.tmi.twitch.tv PRIVMSG #comradenerdy :TaBeRu\r\n"
    {:ok, parsed} = TwitchEvent.parse(raw)
    assert parsed.message == "TaBeRu"
  end

  test "#parse can parse pings" do
    raw = "PING :tmi.twitch.tv\r\n"
    {:ok, parsed} = TwitchEvent.parse(raw)
    assert parsed.irc_command == "PING"
  end

  test "#parse can handle unicode" do
    raw = ":funkycal08!funkycal08@funkycal08.tmi.twitch.tv PRIVMSG #elajjaz :乇乂ㄒ尺卂 ㄒ卄丨匚匚\r\n"
    {:ok, parsed} = TwitchEvent.parse(raw)
    assert parsed.message == "乇乂ㄒ尺卂 ㄒ卄丨匚匚"
  end
end
