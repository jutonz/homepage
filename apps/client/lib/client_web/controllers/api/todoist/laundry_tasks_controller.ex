defmodule ClientWeb.Api.Todoist.LaundryTasksController do
  use ClientWeb, :controller

  alias Client.Todoist

  def create(conn, _params) do
    case Todoist.create_laundry_task() do
      %{error: false} ->
        send_resp(conn, 200, "created task")

      _ ->
        # TODO: Notify sentry
        send_resp(conn, 500, "failed to create task :(")
    end
  end
end
