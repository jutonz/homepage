defmodule ClientWeb.FoodLogController do
  use ClientWeb, :controller
  alias Client.FoodLogs

  plug :put_view, ClientWeb.FoodLogView

  def index(conn, _params) do
    logs = FoodLogs.list(scope(conn))

    conn
    |> assign(:title, "Food Logs")
    |> render("index.html", logs: logs)
  end

  def new(conn, _params) do
    changeset = FoodLogs.new_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"food_log" => log_params}) do
    case FoodLogs.create(scope(conn), log_params) do
      {:ok, log} ->
        conn
        |> put_flash(:success, "Created!")
        |> redirect(to: ~p"/food-logs/#{log.id}")

      {:error, changeset} ->
        conn
        |> put_flash(:danger, "Unable to create log")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    cs = conn |> scope() |> FoodLogs.get!(id) |> FoodLogs.changeset()
    render(conn, "edit.html", changeset: cs)
  end

  def update(conn, %{"id" => id, "food_log" => log_params}) do
    with {:ok, log} <- FoodLogs.update(scope(conn), id, log_params) do
      redirect(conn, to: ~p"/food-logs/#{log.id}")
    end
  end

  def delete(conn, %{"id" => id}) do
    case FoodLogs.delete(scope(conn), id) do
      {:ok, _log} ->
        redirect(conn, to: ~p"/food-logs")

      {:error, _changeset} ->
        conn
        |> put_flash(:danger, "Failed to delete")
        |> redirect(to: ~p"/food-logs")
    end
  end

  defp scope(conn), do: conn.assigns.scope
end
