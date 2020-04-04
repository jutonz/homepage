defmodule ClientWeb.Api.WaterLogEntryController do
  use ClientWeb, :controller
  alias Client.WaterLogs

  action_fallback(ClientWeb.Api.FallbackController)

  def create(conn, params) do
    entry_params = Map.put(params, "user_id", conn.assigns[:current_user_id])

    with {:ok, entry} <- WaterLogs.create_entry(entry_params) do
      json = %{
        id: entry.id,
        user_id: entry.user_id,
        water_log_id: entry.water_log_id,
        ml: entry.ml
      }

      json(conn, json)
    end
  end
end
