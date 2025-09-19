defmodule ClientWeb.Settings.ApiController do
  use ClientWeb, :controller
  alias Client.ApiTokens

  plug :put_view, ClientWeb.Settings.ApiView

  def show(conn, _params) do
    user_id = Client.Session.current_user_id(conn)
    api_tokens = ApiTokens.list(user_id)
    render(conn, "index.html", api_tokens: api_tokens)
  end
end
