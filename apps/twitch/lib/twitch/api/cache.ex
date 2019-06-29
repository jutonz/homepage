defmodule Twitch.Api.Cache do
  use GenServer

  @one_minute 60000

  ##############################################################################
  # Public API
  ##############################################################################

  @spec cache_key(list(any)) :: String.t()
  def cache_key(targets) when is_list(targets) do
    targets
    |> Enum.map(&thing_to_string/1)
    |> Enum.join()
    |> md5()
    |> Base.encode64()
  end

  @spec cache_key(any()) :: String.t()
  def cache_key(target), do: cache_key([target])

  def get(cache_key) do
    GenServer.call(__MODULE__, {:get, cache_key})
  end

  def set(cache_key, response) do
    GenServer.cast(__MODULE__, {:set, cache_key, response})
  end

  def schedule_unset(cache_key) do
    Process.send_after(__MODULE__, {:unset, cache_key}, @one_minute)
  end

  ##############################################################################
  # GenServer internals
  ##############################################################################

  def start_link([] = _args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([] = _args) do
    cache = %{}
    {:ok, cache}
  end

  def handle_call({:get, cache_key}, _from, cache) do
    {:reply, cache[cache_key], cache}
  end

  def handle_cast({:set, cache_key, value}, cache) do
    schedule_unset(cache_key)
    {:noreply, Map.put(cache, cache_key, value)}
  end

  def handle_info({:unset, cache_key}, cache) do
    {:noreply, Map.delete(cache, cache_key)}
  end

  @spec md5(String.t()) :: String.t()
  def md5(string), do: :crypto.hash(:md5, string)

  defp thing_to_string(thing) when is_list(thing) do
    thing |> Enum.map(&thing_to_string/1) |> Enum.join()
  end

  defp thing_to_string(thing) when is_tuple(thing) do
    thing |> Tuple.to_list() |> thing_to_string()
  end

  defp thing_to_string(thing), do: to_string(thing)
end
