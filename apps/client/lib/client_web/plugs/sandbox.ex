defmodule ClientWeb.Plugs.Sandbox do
  # import Plug.Conn
  # alias Plug.Conn

  # def init(opts \\ []) do
  # Phoenix.Ecto.SQL.Sandbox.init(opts)
  # end

  # def call(conn, args) do
  # raise "asdfaf"
  # Phoenix.Ecto.SQL.Sandbox.call(conn, args)
  # end

  def allow(repo, owner_pid, child_pid) do
    Ecto.Adapters.SQL.Sandbox.allow(repo, owner_pid, child_pid)
  end
end
