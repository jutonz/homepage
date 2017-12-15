defmodule Redis do
  @moduledoc """
  Wrapper for Redix dependency.
  """

  def command(command) do
    Redix.command(:redix, command)
  end
end
