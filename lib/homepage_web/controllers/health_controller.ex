defmodule HomepageWeb.HealthController do
  use HomepageWeb, :controller

  def index(conn, _params) do
    conn
    |> send_resp(200, "")
  end
end
