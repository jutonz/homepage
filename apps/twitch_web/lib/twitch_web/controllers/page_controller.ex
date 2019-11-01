defmodule TwitchWeb.PageController do
  use TwitchWeb, :controller

  def index(conn, _params) do
    send_resp(conn, 200, "hey")
  end
end
