defmodule Client.Sandbox do
  def allow(repo, owner_pid, child_pid) do
    IO.puts "hey"
    Ecto.Adapters.SQL.Sandbox.allow(repo, owner_pid, child_pid)
  end
end
