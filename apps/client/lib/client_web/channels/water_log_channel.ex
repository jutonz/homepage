defmodule ClientWeb.WaterLogChannel do
  alias Client.WaterLogs
  alias Client.WaterLogs.WaterLog
  require Logger
  use Phoenix.Channel

  def join("water_log:" <> water_log_id, _msg, socket) do
    case WaterLogs.get(socket.assigns.scope, water_log_id) do
      %WaterLog{} = log -> {:ok, assign(socket, :water_log_id, log.id)}
      nil -> {:error, %{"reason" => "no such water log"}}
    end
  end

  def handle_in("set_ml", %{"ml" => ml}, %{assigns: assigns} = socket) do
    Logger.info("Setting ml to #{ml} #{inspect(assigns)}")
    publish_event(assigns[:water_log_id], {:set_ml, %{"ml" => ml}})
    {:noreply, assign(socket, :ml, ml)}
  end

  def handle_in("commit", %{"ml" => ml}, %{assigns: assigns} = socket) do
    publish_event(assigns[:water_log_id], {:saving, %{"ml" => ml}})

    case WaterLogs.create_entry(assigns.scope, assigns[:water_log_id], %{ml: ml}) do
      {:ok, _entry} ->
        publish_event(assigns[:water_log_id], :saved)

        {:noreply, assign(socket, :ml, 0)}

      {:error, changeset} ->
        error = %{
          "error" => Client.Util.errors_to_sentence(changeset)
        }

        {:reply, {:error, error}, socket}
    end
  end

  def handle_in("weight", %{"g" => g}, %{assigns: assigns} = socket) do
    publish_event(assigns[:water_log_id], {:weight, g})
    {:noreply, socket}
  end

  defp publish_event(log_id, event) do
    Phoenix.PubSub.broadcast!(
      Client.PubSub,
      "water_log_internal:#{log_id}",
      event
    )
  end
end
