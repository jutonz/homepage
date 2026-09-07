defmodule ClientWeb.WaterFilterController do
  use ClientWeb, :controller
  alias Client.WaterLogs

  plug :put_view, ClientWeb.WaterFilterView

  def index(conn, %{"water_log_id" => log_id}) do
    scope = conn.assigns.scope
    log = WaterLogs.get!(scope, log_id)
    filters = WaterLogs.list_filters(scope, log.id)
    render(conn, "index.html", log: log, filters: filters)
  end

  def new(conn, %{"water_log_id" => log_id}) do
    log = WaterLogs.get!(conn.assigns.scope, log_id)
    changeset = WaterLogs.new_filter_changeset()
    render(conn, "new.html", changeset: changeset, log_id: log.id)
  end

  def create(conn, %{"water_log_id" => log_id, "filter" => filter_params}) do
    case WaterLogs.create_filter(conn.assigns.scope, log_id, filter_params) do
      {:ok, _filter} ->
        redirect(conn, to: Routes.water_log_filters_path(conn, :index, log_id))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, log_id: log_id)
    end
  end

  def edit(conn, %{"water_log_id" => log_id, "id" => id}) do
    changeset =
      conn.assigns.scope
      |> WaterLogs.get_filter!(log_id, id)
      |> WaterLogs.filter_changeset()

    render(conn, "edit.html", changeset: changeset, id: id)
  end

  def update(conn, %{"water_log_id" => log_id, "id" => id, "filter" => filter_params}) do
    case WaterLogs.update_filter(conn.assigns.scope, log_id, id, filter_params) do
      {:ok, _filter} ->
        redirect(conn, to: Routes.water_log_filters_path(conn, :index, log_id))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, id: id)
    end
  end

  def delete(conn, %{"id" => id, "water_log_id" => log_id}) do
    index_path = Routes.water_log_filters_path(conn, :index, log_id)

    case WaterLogs.delete_filter(conn.assigns.scope, log_id, id) do
      {:ok, _filter} -> redirect(conn, to: index_path)
      {:error, _changeset} -> redirect(conn, to: index_path)
    end
  end
end
