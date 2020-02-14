defmodule ClientWeb.Plugs.ApiAuthenticated do
  alias Client.ApiTokens

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, header} <- auth_header(conn),
         {:ok, token} <- token_from_auth_header(header),
         api_token when is_map(api_token) <- ApiTokens.get_by_token(token) do
      conn
      |> Plug.Conn.assign(:current_user_id, api_token.user_id)
      |> Plug.Conn.assign(:api_token, api_token)
    else
      {:error, reason} ->
        conn
        |> Plug.Conn.send_resp(401, reason)
        |> Plug.Conn.halt()

      error ->
        conn
        |> Plug.Conn.send_resp(401, error)
        |> Plug.Conn.halt()
    end
  end

  def auth_header(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [] -> {:error, "No authorization header present"}
      [token] -> {:ok, token}
    end
  end

  def token_from_auth_header(header) do
    if String.starts_with?(header, "Bearer ") do
      "Bearer " <> token = header
      {:ok, token}
    else
      {:error, "Authorization header should contain \"Bearer <token>\""}
    end
  end
end
