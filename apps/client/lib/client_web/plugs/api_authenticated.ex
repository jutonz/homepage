defmodule ClientWeb.Plugs.ApiAuthenticated do
  @moduledoc """
  Establishes identity for API-token requests, assigning a `Client.Scope` for
  the token's user.
  """

  alias Client.ApiTokens
  alias Client.ApiTokens.ApiToken
  alias Client.Scope

  @invalid_token "The authorization header contains an invalid token"

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, header} <- auth_header(conn),
         {:ok, token} <- token_from_auth_header(header),
         {:ok, api_token} <- get_api_token(token),
         {:ok, scope} <- scope_for_token(api_token) do
      conn
      |> Plug.Conn.assign(:current_user_id, api_token.user_id)
      |> Plug.Conn.assign(:api_token, api_token)
      |> Plug.Conn.assign(:scope, scope)
    else
      {:error, reason} ->
        conn
        |> Plug.Conn.send_resp(401, reason)
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

  @spec get_api_token(String.t()) :: {:ok, ApiToken.t()} | {:error, String.t()}
  defp get_api_token(token) do
    case ApiTokens.get_by_token(token) do
      nil -> {:error, @invalid_token}
      token -> {:ok, token}
    end
  end

  # A token outliving its user names nobody, so it authenticates nobody.
  @spec scope_for_token(ApiToken.t()) :: {:ok, Scope.t()} | {:error, String.t()}
  defp scope_for_token(%ApiToken{user_id: user_id}) do
    case Scope.for_user_id(user_id) do
      %Scope{} = scope -> {:ok, scope}
      nil -> {:error, @invalid_token}
    end
  end
end
