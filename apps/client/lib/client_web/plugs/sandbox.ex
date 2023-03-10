defmodule ClientWeb.Plugs.Sandbox do
  def allow(repo, owner_pid, child_pid) do
    Ecto.Adapters.SQL.Sandbox.allow(repo, owner_pid, child_pid)
  end
end
