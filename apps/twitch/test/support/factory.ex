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
end
