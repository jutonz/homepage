defmodule ClientWeb.Settings.ApiController do
  use ClientWeb, :controller
  alias Client.ApiTokens

  plug :put_view, ClientWeb.Settings.ApiView

  def show(conn, _params) do
    api_tokens = ApiTokens.list(conn.assigns.scope)
    render(conn, "index.html", api_tokens: api_tokens)
  end
end
