defmodule ClientWeb.Settings.Api.Controller do
  use ClientWeb, :controller
  alias Client.ApiTokens

  def index(conn, _params) do
    user_id = Client.Session.current_user_id(conn)
    api_tokens = ApiTokens.list_by_user_id(user_id)
    render(conn, "index.html", api_tokens: api_tokens)
  end
end
