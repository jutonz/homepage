defmodule Twitch.ApiCacheTest do
  use Twitch.DataCase, async: true
  alias Twitch.ApiCache

  describe "caching" do
    setup do
      name = :rand.uniform() |> to_string() |> String.to_atom()
      cache = start_supervised!({Twitch.ApiCache, name})
      %{cache: cache}
    end

    test "allows setting and getting a cache key", %{cache: cache} do
      cache_key = "key!"
      cache_value = "value!"
      ApiCache.set(cache, cache_key, cache_value)

      assert ApiCache.get(cache, cache_key) == cache_value
    end

    test "returns nil if the cache key is empty", %{cache: cache} do
      assert ApiCache.get(cache, "doesn't exist") == nil
    end

    test "allows unestting a cache key", %{cache: cache} do
      cache_key = "key!"
      cache_value = "value!"
      ApiCache.set(cache, cache_key, cache_value)

      send(cache, {:unset, cache_key})

      assert ApiCache.get(cache, cache_key) == nil
    end
  end

  describe "cache_key/1" do
    test "returns a string when I pass a string" do
      input = "hey"
      response = ApiCache.cache_key(input)
      assert Kernel.is_binary(response)
    end

    test "returns a string when I pass a list of strings" do
      input = ["one", "two"]
      response = ApiCache.cache_key(input)
      assert Kernel.is_binary(response)
    end

    test "returns a string when I pass a list of tuples" do
      input = [{"hey", "I'm a tuple"}]
      response = ApiCache.cache_key(input)
      assert Kernel.is_binary(response)
    end
  end
end
