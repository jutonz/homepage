defmodule ClientWeb.WaterFilterController do
  use ClientWeb, :controller
  alias Client.WaterLogs

  def index(conn, %{"water_log_id" => log_id} = _params) do
    log = WaterLogs.get(log_id)
    filters = WaterLogs.list_filters_by_log_id(log.id)
    render(conn, "index.html", log: log, filters: filters)
  end

  def new(conn, %{"water_log_id" => log_id} = _params) do
    changeset = WaterLogs.new_filter_changeset()
    render(conn, "new.html", changeset: changeset, log_id: log_id)
  end

  def create(conn, params) do
    log_id = params["water_log_id"]

    filer_params =
      params
      |> Map.get("filter")
      |> Map.put("water_log_id", log_id)

    index_path = Routes.water_log_filters_path(conn, :index, log_id)

    case WaterLogs.create_filter(filer_params) do
      {:ok, _filter} ->
        redirect(conn, to: index_path)

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, log_id: log_id)
    end
  end

  def delete(conn, %{"id" => id, "water_log_id" => log_id}) do
    index_path = Routes.water_log_filters_path(conn, :index, log_id)

    case WaterLogs.delete_filter(id) do
      {:ok, _filter} ->
        redirect(conn, to: index_path)

      {:error, changeset} ->
        IO.inspect(changeset)
        redirect(conn, to: index_path)
    end
  end
end
