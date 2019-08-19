defmodule Twitch.ApiCache do
  use GenServer

  @one_minute 60000
  @default_server Application.get_env(:twitch, :api_cache_name)

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

  def get(server \\ @default_server, cache_key) do
    GenServer.call(server, {:get, cache_key})
  end

  def set(server \\ @default_server, cache_key, response, ttl \\ @one_minute) do
    GenServer.cast(server, {:set, cache_key, response, ttl})
  end

  def schedule_unset(server \\ @default_server, cache_key, ttl) do
    Process.send_after(server, {:unset, cache_key}, ttl)
  end

  ##############################################################################
  # GenServer internals
  ##############################################################################

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def init(name) do
    table = :ets.new(name, ~w[set private named_table]a)
    state = %{table: table}
    {:ok, state}
  end

  def handle_call({:get, cache_key}, _from, state) do
    value =
      case :ets.lookup(state[:table], cache_key) do
        [{^cache_key, value}] -> value
        _ -> nil
      end

    {:reply, value, state}
  end

  def handle_cast({:set, cache_key, value, ttl}, state) do
    schedule_unset(self(), cache_key, ttl)
    true = :ets.insert(state[:table], {cache_key, value})
    {:noreply, state}
  end

  def handle_info({:unset, cache_key}, state) do
    :ets.delete(state[:table], cache_key)
    {:noreply, state}
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
