defmodule HomepageWeb.Plugs.Context do
  import Plug.Conn
  alias HomepageWeb.Helpers.UserSession

  def init(opts), do: opts

  def call(conn, _opts) do
    context = conn |> build_current_user_context
    conn |> put_private(:absinthe, %{context: context})
  end

  defp build_current_user_context(conn) do
    case conn |> resource_from_conn do
      {:ok, user} -> %{current_user: user}
      _ -> %{}
    end
  end

  defp resource_from_conn(conn) do
    case conn |> fetch_session |> UserSession.current_user do
      user -> {:ok, user}
      nil -> {:error, "No current user"}
    end
  end

  #defp resource_from_conn(conn) do
    #with {:ok, token} <- conn |> token_from_conn,
         #{:ok, resource, _claims} <- token |> Homepage.GuardianSerializer.resource_from_token,
      #do: {:ok, resource},
      #else: ({:error, reason} -> {:error, reason})
  #end

  ##
  # Support passing token in a couple different methods:
  #
  # 1. As a header: Authentication: Bearer <TOKEN>
  # 2. As a cookie: _session_id: <TOKEN>
  #
  # Sessions are server-managed by default so in the "real world" we always use
  # cookies, but for debugging purposes it's often easier to use headers.
  #
  # In either case, this returns {:ok, token} or {:error, reason}
  #defp token_from_conn(conn) do
    #cond do
      #{:ok, token} = token_from_cookie(conn) -> {:ok, token}
      #{:ok, token} = token_from_header(conn) -> {:ok, token}
      #true -> {:error, "Could not find token in Authorization header or _session_id cookie"}
    #end
  #end

  #defp token_from_cookie(conn) do
    #case conn.cookies["_session_id"] do
      #token -> {:ok, token}
      #nil -> {:error, "Could not find token in _session_id cookie"}
    #end
  #end

  #defp token_from_header(conn) do
    #case conn |> get_req_header("authorization") do
      #["Bearer " <> token] -> {:ok, token}
      #_ -> {:error, "Could not find Bearer token in Authorization header"}
    #end
  #end
end
