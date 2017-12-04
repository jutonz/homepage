defmodule ClientWeb.HealthController do
  use ClientWeb, :controller

  def check(conn, _params) do
    conn |> send_resp(200, "")
  end
end
