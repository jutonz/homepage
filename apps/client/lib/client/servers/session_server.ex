defmodule Client.SessionServer do
  @moduledoc """
  Server responsible for user session management.
  """
  use GenServer
  import Plug.Conn
  alias Client.{User,Repo,UserServer}

  # Client API

  def start_link(opts \\ []) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], opts)
  end

  def login(conn, email, password) do
    GenServer.call(:session_server, {:login, conn, email, password})
  end

  @doc """
  Instantiate a session with the given token. The token is consumed in the
  process and will not be valid for subsequent calls.
  """
  def exchange(conn, token) do
    GenServer.call(:session_server, {:exchange, conn, token})
  end

  def logout(conn) do
    GenServer.call(:session_server, {:logout, conn})
  end

  def current_user(conn) do
    GenServer.call(:session_server, {:current_user, conn})
  end

  def signup(conn, email, password) do
    GenServer.call(:session_server, {:signup, conn, email, password})
  end

  # Server API

  def handle_call({:login, conn, email, password}, _from, state) do
    with {:ok, user} <- UserServer.get_by_email(email),
         {:ok, _pass} <- Auth.check_password(password, user.password_hash),
         {:ok, conn} <- init_user_session(conn, user),
      do: {:reply, {:ok, user, conn}, state},
      else: (
        {:error, reason} -> {:reply, {:error, reason}, state}
        _ -> {:reply, {:error, "Failed to login"}, state}
      )
  end

  def handle_call({:exchange, conn, token}, _from, state) do
    with {:ok, user, claims} <- Auth.resource_for_single_use_jwt(token),
         {:ok, conn} <- init_user_session(conn, user),
         {:ok, _resp} <- Auth.revoke_single_use_token(claims["jti"]),
      do: {:reply, {:ok, user, conn}, state},
      else: (
        {:error, reason} -> {:reply, {:error, reason}, state}
        _ -> {:reply, {:error, "Failed to login"}, state}
      )
  end

  def handle_call({:signup, conn, email, password}, _from, state) do
    changeset = User.changeset(%User{}, %{ email: email, password: password })
    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, conn} = init_user_session(conn, user)
        {:reply, {:ok, user, conn}, state}
      {:error, result} ->
        errors =
          Keyword.keys(result.errors)
            |> Enum.map(fn(key) ->
              message = result.errors[key] |> elem(0)
              to_string(key) <> " " <> message
            end)
            |> Enum.join(", ")
        {:reply, {:error, errors}, state}
    end
  end

  def handle_call({:logout, conn}, _from, state) do
    conn = conn
      |> put_session(:user_id, nil)
      |> assign(:current_user, nil)

    {:reply, {:ok, conn}, state}
  end

  def handle_call({:current_user, conn}, _from, state) do
    user = conn.assigns[:current_user] || load_current_user(conn)

    if user |> is_nil do
      {:reply, {:error, "Unauthenticated"}, state}
    else
      {:reply, {:ok, user}, state}
    end
  end

  @doc """
  Create an authenticated session for the given user. The user will be from
  this point on able to make authenticated API calls using this session.

  Returns conn (now with session info)
  """
  def init_user_session(conn, user) do
    conn = conn
      |> assign(:current_user, user)
      |> put_session(:user_id, user.id)
      |> configure_session(renew: true)

    {:ok, conn}
  end

  defp load_current_user(conn) do
    user_id = conn |> get_session(:user_id)
    if user_id do
      User |> Repo.get(user_id)
    end
  end
end
