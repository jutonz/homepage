defmodule ClientWeb.Api.WaterLogEntryController do
  use ClientWeb, :controller
  alias Client.WaterLogs

  action_fallback(ClientWeb.Api.FallbackController)

  def create(conn, %{"water_log_id" => log_id} = params) do
    with {:ok, entry} <- WaterLogs.create_entry(conn.assigns.scope, log_id, params) do
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
