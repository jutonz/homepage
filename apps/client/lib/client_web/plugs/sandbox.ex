defmodule ClientWeb.Plugs.Sandbox do
  defdelegate checkin(repo, args), to: Ecto.Adapters.SQL.Sandbox
  defdelegate checkout(repo, args), to: Ecto.Adapters.SQL.Sandbox

  def allow(repo, owner_pid, child_pid, opts) do
    Ecto.Adapters.SQL.Sandbox.allow(repo, owner_pid, child_pid, opts)
  end
end
