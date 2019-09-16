defmodule ClientWeb.Settings.ApiController do
  use ClientWeb, :controller

  def index(conn, _params) do
    user_id = Client.Session.current_user_id(conn)
    api_tokens = Client.ApiToken.Controller.list_by_user_id(user_id)
    render(conn, "index.html", api_tokens: api_tokens)
  end
end
