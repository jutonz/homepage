defmodule ClientWeb.FoodLogController do
  use ClientWeb, :controller
  alias Client.FoodLogs

  def index(conn, _params) do
    logs =
      conn
      |> Client.Session.current_user_id()
      |> FoodLogs.by_owner_id()

    render(conn, "index.html", logs: logs)
  end

  def new(conn, _params) do
    changeset = FoodLogs.new_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"food_log" => log_params}) do
    insert_result =
      log_params
      |> Map.put("owner_id", Client.Session.current_user_id(conn))
      |> FoodLogs.create()

    case insert_result do
      {:ok, log} ->
        conn
        |> put_flash(:success, "Created!")
        |> redirect(to: food_log_path(ClientWeb.Endpoint, :show, log.id))

      {:error, changeset} ->
        conn
        |> put_flash(:danger, "Unable to create log")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    log = FoodLogs.get(id)
    render(conn, "show.html", log: log)
  end

  def delete(conn, %{"id" => id}) do
    case FoodLogs.delete(id) do
      {:ok, _log} ->
        redirect(conn, to: food_log_path(ClientWeb.Endpoint, :index))

      {:error, _changeset} ->
        conn
        |> put_flash(:danger, "Failed to delete")
        |> redirect(to: settings_api_path(ClientWeb.Endpoint, :show))
    end
  end
end
