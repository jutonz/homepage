defmodule Twitch.ApiCache do
  use GenServer

  ##############################################################################
  # Public API
  ##############################################################################

  @spec cache_key(any | list(any)) :: String.t()

  def cache_key(targets) when is_list(targets) do
    targets
    |> Enum.map(&thing_to_string/1)
    |> Enum.join()
    |> md5()
    |> Base.encode64()
  end

  def cache_key(target), do: cache_key([target])

  def get(pid_or_name, cache_key) do
    GenServer.call(pid_or_name, {:get, cache_key})
  end

  @one_minute 60000
  def set(pid_or_name, cache_key, response, ttl \\ @one_minute) do
    GenServer.cast(pid_or_name, {:set, cache_key, response, ttl})
  end

  def schedule_unset(pid_or_name, cache_key, ttl) do
    Process.send_after(pid_or_name, {:unset, cache_key}, ttl)
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
