defmodule HomepageWeb.Helpers.UserSession do
  import Plug.Conn
  alias Homepage.User
  alias Homepage.Repo
  import Comeonin.Argon2, only: [check_pass: 2]

  @doc """
  Un-authenticate the current session so that it may no longer be used to make
  authenticated API calls.

  Returns conn
  """
  def logout(conn) do
    conn
      |> put_session(:user_id, nil)
      |> assign(:current_user, nil)
  end

  def current_user(conn) do
    conn.assigns[:current_user] || load_current_user(conn)
  end

  defp load_current_user(conn) do
    user_id = conn |> get_session(:user_id)
    if user_id do
      Homepage.Repo.get Homepage.User, user_id
    end
  end

  @doc """
  Authenticates a user session given a username and password.

  Returns `{:ok, user, conn}` on success, or {:error, reason} on failure
  """
  def login(conn, email, password) do
    case User |> Repo.get_by(email: email) |> check_pass(password) do
      {:ok, user} ->
        conn = conn |> init_user_session(user)
        {:ok, user, conn}
      _ ->
        {:error, "Invalid username or password"}
    end
  end

  @doc """
  Create a user record with the given email and password, also initiating a
  authenticated session.

  Returns {:ok, user, conn} on success or {:error, reason} on failure.
  """
  def signup(conn, email, password) do
    changeset = User.changeset(%User{}, %{ email: email, password: password })
    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, user, init_user_session(conn, user)}
      {:error, result} ->
        errors =
          Keyword.keys(result.errors)
            |> Enum.map(fn(key) ->
              message = result.errors[key] |> elem(0)
              to_string(key) <> " " <> message
            end)
            |> Enum.join(", ")
        {:error, errors}
    end
  end

  @doc """
  Generate an access token for a user given his or her username and password.
  This token can be passed in the Authorization header to make authenticated
  API calls.

  Returns {:ok, %{token: token}} on success, or {:error, reason} on failure.
  """
  def login_jwt(email, password) do
    case User |> Repo.get_by(email: email) |> check_pass(password) do
      {:ok, user} ->
        # Create a generic "access token".
        # TODO potentially look into using per-resource claims
        {:ok, jwt, _claims} = Homepage.GuardianSerializer.encode_and_sign(user, %{}, token_type: "access")
        {:ok, %{token: jwt}}
      _ -> {:error, "Invalid username or password"}
    end
  end

  @doc """
  Create an authenticated session for the given user. The user will be from
  this point on able to make authenticated API calls using this session.

  Returns conn (now with session info)
  """
  def init_user_session(conn, user) do
    conn
      |> assign(:current_user, user)
      |> put_session(:user_id, user.id)
      |> configure_session(renew: true)
  end

  @doc """
  Plug which prevents non-authenticated users from accessing authenticated
  routes.

  Returns conn
  """
  def load_user_or_redirect(conn, _options) do
    if current_user(conn) == nil do
      conn
        |> Phoenix.Controller.put_flash(:error, "Please login")
        |> Phoenix.Controller.redirect(to: "/login")
    end

    conn
  end
end
