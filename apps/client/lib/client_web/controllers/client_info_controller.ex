defmodule ClientWeb.ClientInfoController do
  use ClientWeb, :controller

  def whatismyip(conn, _params) do
    # ip = conn.remote_ip
    # |> Tuple.to_list
    # |> Enum.map(&to_string/1)
    # |> Enum.join(".")

    ip = conn |> get_req_header("x-forwarded-for")
    conn |> send_resp(200, ip)
  end
end
