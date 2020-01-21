defmodule ClientWeb.Api.WaterLogEntryController do
  use ClientWeb, :controller
  alias Client.WaterLogs

  def create(conn, params) do
    insert_result =
      params
      |> Map.put("user_id", conn.assigns[:current_user_id])
      |> WaterLogs.create_entry()

    case insert_result do
      {:ok, entry} ->
        json = %{
          id: entry.id,
          user_id: entry.user_id,
          water_log_id: entry.water_log_id,
          ml: entry.ml
        }

        json(conn, json)

      {:error, _changeset} ->
        send_resp(conn, 400, "Could not create entry")
    end
  end
end
