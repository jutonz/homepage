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

  def seven_tv_emote_factory do
    %Twitch.SevenTv.Emote{
      id: "123",
      name: "nepSmug",
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
      raw_event: ":syps_!syps_@syps_.tmi.twitch.tv PRIVMSG #comradenerdy :Kappa TaBeRu",
      tags: %{
        "emotes" => "25:0-4"
      }
    }
  end

  def twitch_eventsub_subscription_factory do
    %Twitch.Eventsub.Subscription{
      twitch_id: Ecto.UUID.generate(),
      type: "channel.update",
      version: 1,
      condition: %{"broadcaster_user_id" => "26921830"}
    }
  end

  def twitch_channel_update_factory do
    %Twitch.Eventsub.ChannelUpdates.Update{
      twitch_user_id: "1234",
      title: "Playing DS!",
      category_name: "Dark Souls",
      category_id: "123",
      type: "channel.update"
    }
  end
end
