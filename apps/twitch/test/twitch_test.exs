defmodule TwitchTest do
  use ExUnit.Case
  doctest Twitch

  test "greets the world" do
    assert Twitch.hello() == :world
  end
end
