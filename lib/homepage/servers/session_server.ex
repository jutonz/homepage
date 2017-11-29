defmodule Homepage.Servers.SessionServer do
  @moduledoc """
  Server responsible for user session magement.
  """

  use GenServer

  import Plug.Conn

  alias Homepage.User
  alias Homepage.Repo
  alias Homepage.Servers.AuthServer
  alias Homepage.Servers.UserServer

  # Client API

  def start_link(opts \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, [], opts)
  end

  def login(conn, email, password) do
    GenServer.call(:session_server, {:login, conn, email, password})
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

  def handle_call({:login, conn, email, password}, _from, something) do
    with {:ok, user} <- UserServer.get_by_email(email),
         {:ok, _pass} <- AuthServer.check_password(password, user.password_hash),
         {:ok, conn} <- init_user_session(conn, user),
      do: {:reply, {:ok, user, conn}, something},
      else: (_ -> {:reply, {:error, "Failed to login"}, something})
  end

  def handle_call({:signup, conn, email, password}, _from, something) do
    changeset = User.changeset(%User{}, %{ email: email, password: password })
    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, conn} = init_user_session(conn, user)
        {:reply, {:ok, user, conn}, something}
      {:error, result} ->
        errors =
          Keyword.keys(result.errors)
            |> Enum.map(fn(key) ->
              message = result.errors[key] |> elem(0)
              to_string(key) <> " " <> message
            end)
            |> Enum.join(", ")
        {:reply, {:error, errors}, something}
    end
  end

  def handle_call({:logout, conn}, _from, something) do
    conn = conn
      |> put_session(:user_id, nil)
      |> assign(:current_user, nil)

    {:reply, {:ok, conn}, something}
  end

  def handle_call({:current_user, conn}, _from, something) do
    user = conn.assigns[:current_user] || load_current_user(conn)

    if user |> is_nil do
      {:reply, {:error, "Unauthenticated"}, something}
    else
      {:reply, {:ok, user}, something}
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
      Homepage.Repo.get Homepage.User, user_id
    end
  end
end
