defmodule ClientWeb.TrainLogController do
  use ClientWeb, :controller
  alias Client.{Session, Trains}

  plug :put_view, ClientWeb.TrainLogView

  def index(conn, _params) do
    user_id = Session.current_user_id(conn)
    logs = Trains.list_logs(user_id)
    render(conn, "index.html", logs: logs)
  end

  def new(conn, _params) do
    changeset = Trains.new_log_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"log" => log_params}) do
    user_id = Session.current_user_id(conn)
    log_params = Map.put(log_params, "user_id", user_id)

    case Trains.create_log(log_params) do
      {:ok, _log} ->
        redirect(conn, to: Routes.train_log_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, params) do
    session = %{
      "id" => params["id"],
      "user_id" => Session.current_user_id(conn)
    }

    live_render(conn, ClientWeb.TrainLogLive, session: session)
  end
end
