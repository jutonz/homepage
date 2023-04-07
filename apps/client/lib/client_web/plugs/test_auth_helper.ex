defmodule ClientWeb.Plugs.TestAuthHelper do
  import Plug.Conn
  alias Client.{Repo, Session, User}

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> login()
    |> redirect()
  end

  def auth_user(nil = _user, conn),
    do: conn

  def auth_user(user, conn) do
    {:ok, conn} = Session.init_user_session(conn, user)
    conn
  end

  defp login(conn) do
    case Map.get(conn.params, "as") do
      nil -> conn
      user_id -> User |> Repo.get(user_id) |> auth_user(conn)
    end
  end

  defp redirect(conn) do
    case Map.get(conn.params, "to") do
      nil -> conn
      path -> conn |> Phoenix.Controller.redirect(to: path) |> halt()
    end
  end
end
