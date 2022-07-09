defmodule ClientWeb.Storage.ExportController do
  use ClientWeb, :controller

  alias Client.{
    Session,
    Storage
  }

  def create(conn, %{"context_id" => context_id}) do
    csv =
      conn
      |> Session.current_user_id()
      |> Storage.export_to_csv(context_id)

    send_download(
      conn,
      {:binary, csv},
      content_type: "application/csv",
      filename: "export.csv"
    )
  end
end
