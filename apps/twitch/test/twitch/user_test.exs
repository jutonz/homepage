defmodule Twitch.UserTest do
  use ExUnit.Case, async: true
  alias Twitch.{TwitchUser, Repo, Channel}

  it "deletes channel associations on destroy" do
    user = build(:user)

    require IEx; IEx.pry()

    IO.inspect :yo
  end
end
