defmodule ClientWeb.WaterLogController do
  use ClientWeb, :controller
  alias Client.WaterLogs

  plug :put_view, ClientWeb.WaterLogView

  def index(conn, _params) do
    logs =
      conn
      |> Client.Session.current_user_id()
      |> WaterLogs.list_by_user_id()

    conn
    |> assign(:title, "Water Logs")
    |> render("index.html", logs: logs)
  end

  def new(conn, _params) do
    changeset = WaterLogs.new_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"water_log" => log_params}) do
    insert_result =
      log_params
      |> Map.put("user_id", Client.Session.current_user_id(conn))
      |> WaterLogs.create()

    case insert_result do
      {:ok, log} ->
        conn
        |> put_flash(:success, "Created!")
        |> redirect(to: Routes.water_log_path(ClientWeb.Endpoint, :show, log.id))

      {:error, changeset} ->
        IO.inspect(changeset)

        conn
        |> put_flash(:danger, "Unable to create log")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    log = WaterLogs.get(id)
    entries = WaterLogs.list_entries_by_log_id(log.id)

    conn
    |> assign(:title, log.name)
    |> render("show.html", log: log, entries: entries)
  end
end
