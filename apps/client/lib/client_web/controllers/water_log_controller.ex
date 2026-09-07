defmodule ClientWeb.WaterLogController do
  use ClientWeb, :controller
  alias Client.WaterLogs

  plug :put_view, ClientWeb.WaterLogView

  def index(conn, _params) do
    logs = WaterLogs.list(conn.assigns.scope)

    conn
    |> assign(:title, "Water Logs")
    |> render("index.html", logs: logs)
  end

  def new(conn, _params) do
    changeset = WaterLogs.new_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"water_log" => log_params}) do
    case WaterLogs.create(conn.assigns.scope, log_params) do
      {:ok, log} ->
        conn
        |> put_flash(:success, "Created!")
        |> redirect(to: Routes.water_log_path(ClientWeb.Endpoint, :show, log.id))

      {:error, changeset} ->
        conn
        |> put_flash(:danger, "Unable to create log")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    scope = conn.assigns.scope
    log = WaterLogs.get!(scope, id)
    entries = WaterLogs.list_entries(scope, log.id)

    conn
    |> assign(:title, log.name)
    |> render("show.html", log: log, entries: entries)
  end
end
