defmodule HomepageWeb.SessionController do
  use HomepageWeb, :controller
  alias Homepage.User
  alias HomepageWeb.Helpers.UserSession
  import Comeonin.Argon2, only: [check_pass: 2]

  def show_login(conn, _params) do
    # If already logged in, send to /home
    case UserSession.current_user(conn) do
      nil ->
        render conn, :login
      user ->
        redirect conn, to: "/home"
    end
  end

  def login(conn, %{ "email" => email, "password" => password }) do
    case User |> Repo.get_by(email: email) |> check_pass(password) do
      { :ok, user } ->
        conn |> init_user_session(user) |> redirect(to: "/home")
      { :error, _ } ->
        conn
          |> put_flash(:error, "Username or password is invalid")
          |> render(:login)
    end
  end

  def logout(conn, _params) do
    conn
      |> UserSession.logout
      |> redirect(to: "/")
  end

  def show_signup(conn, _params) do
    conn
      |> clear_flash
      |> render(:signup)
  end

  def signup(conn, params) do
    changeset = User.changeset(%User{}, params)
    case Repo.insert(changeset) do
      { :ok, user } ->
        conn |> init_user_session(user) |> redirect(to: "/home/#{user.email}")
      { _, result } ->
        errors =
          Keyword.keys(result.errors)
            |> Enum.map(fn(key) ->
              message = result.errors[key] |> elem(0)
              to_string(key) <> " " <> message
            end)
            |> Enum.join(", ")

        conn
          |> put_flash(:error, "Failed to signup: " <> errors)
          |> render(:signup)
    end
  end

  ##
  # Initialize a session for the given connection and user. Used when logging
  # in and signing up.
  defp init_user_session(conn, user) do
    conn
      |> assign(:current_user, user)
      |> put_session(:user_id, user.id)
      |> configure_session(renew: true)
  end
end
