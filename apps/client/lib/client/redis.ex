defmodule Client.Redis do
  def command(command) do
    Redix.command(:redix, command)
  end
end
