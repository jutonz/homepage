defmodule HomepageWeb.Helpers.UserSession do
  import Plug.Conn
  alias Homepage.User
  alias Homepage.Repo
  import Comeonin.Argon2, only: [check_pass: 2]

  def logout(conn) do
    conn
    |> put_session(:user_id, nil)
    |> assign(:current_user, nil)
  end

  def current_user(conn) do
    conn.assigns[:current_user] || load_current_user(conn)
  end

  defp load_current_user(conn) do
    user_id = get_session conn, :user_id
    if user_id do
      Homepage.Repo.get Homepage.User, user_id
    end
  end

  def login(conn, email, password) do
    case User |> Repo.get_by(email: email) |> check_pass(password) do
      {:ok, user} ->
        init_user_session(conn, user)
        {:ok, user}
      _ ->
        {:error, "Invalid username or password"}
    end
  end

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

  ##
  # Initialize a session for the given connection and user. Used when logging
  # in and signing up.
  def init_user_session(conn, user) do
    conn
      |> assign(:current_user, user)
      |> put_session(:user_id, user.id)
      |> configure_session(renew: true)
  end

  ##
  # This is a plug.
  #
  # If user is authenticated, do nothing. Otherwise redirect to /login.
  def load_user_or_redirect(conn, _options) do
    if current_user(conn) == nil do
      conn
        |> Phoenix.Controller.put_flash(:error, "Please login")
        |> Phoenix.Controller.redirect(to: "/login")
    end

    conn
  end
end
