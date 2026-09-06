defmodule ClientWeb.Plugs.BrowserAuthenticated do
  @moduledoc """
  Establishes browser identity, assigning a `Client.Scope` for the session's
  user.

  A session naming a user who no longer exists is not authenticated: the
  session is dropped and the request redirected to login, rather than being
  allowed through to fail somewhere downstream.
  """

  alias Client.{Scope, Session}

  def init(opts), do: opts

  def call(conn, _opts) do
    case Session.check_session(conn) do
      {:ok, user_id} -> authenticate(conn, user_id)
      {:error, _reason} -> redirect_to_login(conn)
    end
  end

  defp authenticate(conn, user_id) do
    case Scope.for_user_id(user_id) do
      %Scope{} = scope ->
        Plug.Conn.assign(conn, :scope, scope)

      nil ->
        conn
        |> logout()
        |> redirect_to_login()
    end
  end

  defp logout(conn) do
    {:ok, conn} = Session.logout(conn)
    conn
  end

  defp redirect_to_login(conn) do
    conn
    |> Phoenix.Controller.redirect(to: "/#/login?to=#{conn.request_path}")
    |> Plug.Conn.halt()
  end
end
