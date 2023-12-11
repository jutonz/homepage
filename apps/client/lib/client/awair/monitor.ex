defmodule Client.Awair.Monitor do
  use GenServer
  require Logger

  alias Client.Awair.AirData

  def start_link(server) do
    GenServer.start_link(__MODULE__, server, name: name(server))
  end

  def init(server) do
    state = %{
      "name" => server[:name],
      "host" => server[:host],
    }

    {:ok, state, {:continue, :check_connection}}
  end

  def handle_continue(:check_connection, state), do: poll(state)

  def handle_info(:poll, state), do: poll(state)

  defp poll(%{"host" => host} = state) do
    case AirData.latest(host) do
      {:ok, data} ->
        broadcast(data, state)
        schedule_checkin()
        {:noreply, state}

      err ->
        msg =
          case err do
            {:error, reason} -> reason
            err -> err
          end

        warn("Awair connection failed: #{IO.inspect(msg)}")
        {:stop, :connection_failed, state}
    end
  end

  defp broadcast(data, %{"name" => name}) do
    Phoenix.PubSub.broadcast!(Client.PubSub, "awair", %{data: data, name: name})
  end

  @interval 30 # seconds
  defp schedule_checkin do
    Process.send_after(self(), :poll, :timer.seconds(@interval))
  end

  defp warn(msg), do: Logger.warning("[#{__MODULE__}] #{msg}")

  defp name(server), do: String.to_atom("awair_#{server[:name]}")
end
