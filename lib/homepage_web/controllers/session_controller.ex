defmodule HomepageWeb.SessionController do
  use HomepageWeb, :controller
  alias Homepage.User
  alias HomepageWeb.Helpers.UserSession

  def show_login(conn, _params) do
    case UserSession.current_user(conn) do
      nil ->
        render conn, :login
      user ->
        redirect conn, to: "/hello"
    end
  end

  def login(conn, %{ "email" => email, "password" => password }) do
    case Repo.get_by(User, email: email, password: password) do
      nil ->
        conn |> put_flash(:error, "Username or password is invalid") |> render(:login)
      user ->
        conn
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: "/hello")
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
        redirect conn, to: "/hello/#{user.email}"
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
end
