defmodule ClientWeb.Plugs.ApiAuthenticated do
  @moduledoc """
  Establishes identity for API-token requests, assigning a `Client.Scope` for
  the token's user.
  """

  alias Client.ApiTokens.Authentication

  @invalid_token "The authorization header contains an invalid token"

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, header} <- auth_header(conn),
         {:ok, token} <- token_from_auth_header(header),
         {:ok, api_token, scope} <- Authentication.authenticate(token) do
      conn
      |> Plug.Conn.assign(:current_user_id, api_token.user_id)
      |> Plug.Conn.assign(:api_token, api_token)
      |> Plug.Conn.assign(:scope, scope)
    else
      :error -> unauthorized(conn, @invalid_token)
      {:error, reason} -> unauthorized(conn, reason)
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

  defp unauthorized(conn, reason) do
    conn
    |> Plug.Conn.send_resp(401, reason)
    |> Plug.Conn.halt()
  end
end
