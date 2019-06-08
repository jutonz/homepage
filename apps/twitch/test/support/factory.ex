defmodule Twitch.Factory do
  use ExMachina.Ecto, repo: Twitch.Repo

  def user_factory do
    %Twitch.User{
      email: "jutonz42@gmail.com",
      display_name: "syps_",
      user_id: sequence("id"),
      twitch_user_id: sequence("twitch_user_id")
    }
  end

  def channel_factory do
    %Twitch.Channel{
      name: "#comradenerdy",
      user: build(:user)
    }
  end

  def emote_factory do
    %Twitch.Bttv.Emote{
      channel: "cfusion",
      code: "nepSmug",
      id: "55da21e58b9916ef4b249f10",
      image_type: "png",
      regex: ~r/nepSmug/
    }
  end

  def event_factory do
    %Twitch.TwitchEvent{
      channel: "#comradenerdy",
      display_name: "syps_",
      message: "TaBeRu",
      raw_event: ":syps_!syps_@syps_.tmi.twitch.tv PRIVMSG #comradenerdy :TaBeRu"
    }
  end

  def parsed_event_factory do
    %Twitch.ParsedEvent{
      id: sequence("id"),
      channel: "#comradenerdy",
      display_name: "syps_",
      message: "TaBeRu",
      raw_event: ":syps_!syps_@syps_.tmi.twitch.tv PRIVMSG #comradenerdy :TaBeRu"
    }
  end

  def gambling_event_factory do
    event =
      build(:event, %{
        channel: "#comradenerdy",
        message: "syps_ won 566 blyats in roulette and now has 61132 blyats! FeelsGoodMan",
        display_name: "syps_",
        raw_event:
          ":takeitbot!takeitbot@takeitbot.tmi.twitch.tv PRIVMSG #comradenerdy :takeitbot won 566 blyats in roulette and now has 61132 blyats! FeelsGoodMan"
      })

    %Twitch.GamblingEvent{
      channel: "#comradenerdy",
      gamble_type: "routlette",
      won: true,
      twitch_event: event
    }
  end
end
