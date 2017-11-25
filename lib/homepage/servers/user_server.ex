defmodule Homepage.Servers.UserServer do
  @moduledoc """
  Server responsible for accessing and modifying user records.
  """
  use GenServer

  alias Homepage.User
  alias Homepage.Repo

  # Client API

  def start_link(opts \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, [], opts)
  end

  def get_by_email(email) do
    GenServer.call(:user_server, {:get_by_email, email})
  end

  # Server API

  def handle_call({:get_by_email, email}, _from, something) do
    case User |> Repo.get_by(email: email) do
      user = %User{} -> {:reply, {:ok, user}, something}
      _ -> {:reply, {:error, "No user with email #{email}"}, something}
    end
  end
end
