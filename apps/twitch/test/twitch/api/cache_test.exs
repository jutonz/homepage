defmodule Twitch.Api.CacheTest do
  use Twitch.DataCase, async: true
  alias Twitch.Api.Cache

  describe "cache_key/1" do
    test "returns a string when I pass a string" do
      input = "hey"
      response = Cache.cache_key(input)
      assert Kernel.is_binary(response)
    end

    test "returns a string when I pass a list of strings" do
      input = ["one", "two"]
      response = Cache.cache_key(input)
      assert Kernel.is_binary(response)
    end

    test "returns a string when I pass a list of tuples" do
      input = [{"hey", "I'm a tuple"}]
      response = Cache.cache_key(input)
      assert Kernel.is_binary(response)
    end
  end
end
