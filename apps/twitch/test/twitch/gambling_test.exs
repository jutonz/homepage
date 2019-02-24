defmodule Twitch.GamblingTest do
  use ExUnit.Case, async: true
  alias Twitch.Gambling

  test ".gambling? ignores messages not from takeitbot" do
    event = %Twitch.ParsedEvent{
      irc_command: "PRIVMSG",
      display_name: "not-takeitbot",
      message:
        "Paladin_Neptune lost 100 blyats in roulette and now has 10195 blyats!  FeelsBadMan"
    }

    assert Gambling.gambling?(event) == false
  end

  test ".gambling? ignores events that are not PRIVMSG" do
    event = %Twitch.ParsedEvent{
      irc_command: "ACTION",
      display_name: "takeitbot",
      message:
        "Paladin_Neptune lost 100 blyats in roulette and now has 10195 blyats!  FeelsBadMan"
    }

    assert Gambling.gambling?(event) == false
  end

  test ".roulette? is false for a non-roulette message" do
    event = %Twitch.ParsedEvent{
      irc_command: "PRIVMSG",
      display_name: "takeitbot",
      message: "Welcome back grantelmann! Loyal dungeon member for 12 months in a row  gachiGASM"
    }

    assert Gambling.roulette?(event) == false
  end

  test ".roulette? detects a losing roulette message" do
    event = %Twitch.ParsedEvent{
      irc_command: "PRIVMSG",
      display_name: "takeitbot",
      message:
        "Paladin_Neptune lost 100 blyats in roulette and now has 10195 blyats!  FeelsBadMan"
    }

    assert {:roulette, :lost, _} = Gambling.roulette?(event)
  end

  test ".roulette? detects a winning roulette message" do
    event = %Twitch.ParsedEvent{
      irc_command: "PRIVMSG",
      display_name: "takeitbot",
      message: "Nostraz won 566 blyats in roulette and now has 61132 blyats! FeelsGoodMan"
    }

    assert {:roulette, :won, _} = Gambling.roulette?(event)
  end

  test ".roulette? detects a losing all-in message" do
    event = %Twitch.ParsedEvent{
      irc_command: "PRIVMSG",
      display_name: "takeitbot",
      message: "Clixx went all in and lost every single one of their 10980 blyats LUL"
    }

    assert {:roulette, :lost, _} = Gambling.roulette?(event)
  end

  test ".roulette? detects a winning all-in message" do
    event = %Twitch.ParsedEvent{
      irc_command: "PRIVMSG",
      display_name: "takeitbot",
      message:
        "PogChamp anonssr1 went all in and won 240 blyats PogChamp they now have 480 blyats  FeelsGoodMan"
    }

    assert {:roulette, :won, _} = Gambling.roulette?(event)
  end

  test ".gambling? detects a losing slots message" do
    event = %Twitch.ParsedEvent{
      irc_command: "PRIVMSG",
      display_name: "takeitbot",
      message:
        "@Nostraz you got  gachiBLYAT | gachiBLYAT |  TakeItBoi and i'm taking these 200 blyats  gachiCOOL"
    }

    assert {:slots, :lost, _} = Gambling.gambling?(event)
  end

  test ".gambling? detects a winning slots message" do
    event = %Twitch.ParsedEvent{
      irc_command: "PRIVMSG",
      display_name: "takeitbot",
      message:
        "@Nostraz you got  FeelsBlyatMan | FeelsBlyatMan |  FeelsBlyatMan and U VON 4000 blyats  ZULUL"
    }

    assert {:slots, :won, _} = Gambling.gambling?(event)
  end
end
