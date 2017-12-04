defmodule Client.UserServer do
  @moduledoc """
  Server responsible for accessing and modifying user records.
  """
  use GenServer

  alias Client.User
  alias Client.Repo
  alias Client.AuthServer

  # Client API

  def start_link(opts \\ []) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], opts)
  end

  def get_by_email(email) do
    GenServer.call(:user_server, {:get_by_email, email})
  end

  def change_password(user, current_pw, new_pw) do
    GenServer.call(:user_server, {:change_password, user, current_pw, new_pw})
  end

  # Server API

  def handle_call({:get_by_email, email}, _from, something) do
    case User |> Repo.get_by(email: email) do
      user = %User{} -> {:reply, {:ok, user}, something}
      _ -> {:reply, {:error, "No user with email #{email}"}, something}
    end
  end

  def handle_call({:change_password, user, current_pw, new_pw}, _from, something) do
    with {:ok, _pass} <- AuthServer.check_password(current_pw, user.password_hash),
         changeset <- User.changeset(user, %{ password: new_pw }),
         {:ok, user} <- Repo.update(changeset),
      do: {:reply, {:ok, user}, something},
      else: (
        {:error, reason} -> {:reply, {:error, reason}, something}
        _ -> {:reply, {:error, "Could not change password"}, something}
      )
  end
end
