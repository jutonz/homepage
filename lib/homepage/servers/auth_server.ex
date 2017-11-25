defmodule Homepage.Servers.AuthServer do
  @moduledoc """
  Server responsible for password validation and hashing.

  Anything related to password creation or validation should live here.
  """
  use GenServer

  alias Homepage.User
  alias Homepage.Repo

  # Client API

  def start_link(opts \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, [], opts)
  end

  def check_password(password, hash) do
    GenServer.call(:auth_server, {:check_password, password, hash})
  end

  # Server API

  def handle_call({:check_password, password, hash}, _from, something) do
    case Comeonin.Argon2.checkpw(password, hash) do
      true -> {:reply, {:ok, password}, something}
      _ -> {:reply, {:error, "Invalid password"}, something}
    end
  end
end
