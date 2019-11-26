defmodule ClientWeb.Plugs.TestAuthHelper do
  alias Client.Repo
  alias Client.Session
  alias Client.User

  def init(opts), do: opts

  def call(conn, _opts) do
    case Map.get(conn.params, "as") do
      nil -> conn
      user_id -> User |> Repo.get(user_id) |> auth_user(conn)
    end
  end

  def auth_user(nil = _user, conn),
    do: conn

  def auth_user(user, conn) do
    {:ok, conn} = Session.init_user_session(conn, user)
    conn
  end
end
