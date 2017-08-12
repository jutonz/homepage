defmodule Homepage.Web.HealthController do
  use Homepage.Web, :controller

  def index(conn, _params) do
    conn
    |> send_resp(200, "")
  end
end
