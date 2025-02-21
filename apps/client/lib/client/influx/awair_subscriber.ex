defmodule Client.Influx.AwairSubscriber do
  use GenServer

  alias Client.Influx

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  def init(_arg) do
    state = nil
    {:ok, state, {:continue, :subscribe}}
  end

  def handle_continue(:subscribe, state) do
    Phoenix.PubSub.subscribe(Client.PubSub, "awair")
    {:noreply, state}
  end

  def handle_info(%{data: _data, name: _name} = event, state) do
    event
    |> to_line_data()
    |> Influx.write("data")

    {:noreply, state}
  end

  def handle_info(_, state), do: {:noreply, state}

  defp to_line_data(%{data: data, name: name}) do
    %Influx.LineData{
      measurement: "air_quality",
      tags: %{"server" => name},
      values: data |> JSON.encode!() |> JSON.decode!(),
      timestamp: data.timestamp
    }
  end
end
