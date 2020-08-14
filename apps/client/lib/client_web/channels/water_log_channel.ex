defmodule ClientWeb.WaterLogChannel do
  alias Client.WaterLogs
  require Logger
  use Phoenix.Channel

  def join("water_log:" <> water_log_id, _msg, socket) do
    user_id = socket.assigns[:user_id]

    case WaterLogs.get_by_user_id(user_id, water_log_id) do
      nil -> {:error, %{"reason" => "no such water log"}}
      _log -> {:ok, assign(socket, :water_log_id, water_log_id)}
    end
  end

  def handle_in("set_ml", %{"ml" => ml}, %{assigns: assigns} = socket) do
    Logger.info("Setting ml to #{ml} #{inspect(assigns)}")
    publish_event(assigns[:water_log_id], {:set_ml, %{"ml" => ml}})
    {:noreply, assign(socket, :ml, ml)}
  end

  def handle_in("commit", %{"ml" => ml}, %{assigns: assigns} = socket) do
    entry_params = %{
      ml: ml,
      user_id: assigns[:user_id],
      water_log_id: assigns[:water_log_id]
    }

    publish_event(assigns[:water_log_id], {:saving, %{"ml" => ml}})

    case WaterLogs.create_entry(entry_params) |> IO.inspect() do
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

  defp publish_event(log_id, event) do
    Phoenix.PubSub.broadcast!(
      Client.PubSub,
      "water_log_internal:#{log_id}",
      event
    )
  end
end
