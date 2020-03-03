defmodule ClientWeb.WaterFilterController do
  use ClientWeb, :controller
  alias Client.WaterLogs

  def index(conn, %{"water_log_id" => log_id} = _params) do
    log = WaterLogs.get(log_id)
    filters = WaterLogs.list_filters_by_log_id(log.id)
    render(conn, "index.html", log: log, filters: filters)
  end

  def create(conn, %{"water_log_id" => log_id} = params) do
    index_path = water_log_filters_path(conn, :index, log_id)

    case WaterLogs.create_filter(params) do
      {:ok, _filter} ->
        redirect(conn, to: index_path)

      {:error, changeset} ->
        IO.inspect(changeset)
        redirect(conn, to: index_path)
    end
  end

  def delete(conn, %{"id" => id, "water_log_id" => log_id}) do
    index_path = water_log_filters_path(conn, :index, log_id)

    case WaterLogs.delete_filter(id) do
      {:ok, _filter} ->
        redirect(conn, to: index_path)

      {:error, changeset} ->
        IO.inspect(changeset)
        redirect(conn, to: index_path)
    end
  end
end
