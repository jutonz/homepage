defmodule ClientWeb.Settings.ApiController do
  use ClientWeb, :controller

  def index(conn, _params) do
    {:ok, user} = Client.Session.current_user(conn)
    render(conn, "index.html", user: user)
  end
end
