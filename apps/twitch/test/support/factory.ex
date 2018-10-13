defmodule Twitch.Factory do
  use ExMachina.Ecto, repo: Twitch.Repo

  def user_factory do
    %Twitch.User{
      email: "jutonz42@gmail.com",
      display_name: "syps_",
      user_id: "123",
      twitch_user_id: "456"
    }
  end

  def channel_factory do
    %Twitch.Channel{
      name: "#comradenerdy",
      user: build(:user)
    }
  end
end
