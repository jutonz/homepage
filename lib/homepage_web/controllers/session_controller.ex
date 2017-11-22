defmodule HomepageWeb.SessionController do
  use HomepageWeb, :controller
  alias Homepage.User
  alias HomepageWeb.Helpers.UserSession

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
    case conn |> UserSession.login(email, password) do
      {:ok, user, conn} ->
        #conn
          #|> put_status(200)
          #|> json(%{ error: false })
          conn |> redirect(to: "/home")
      {:error, reason} ->
        conn
          |> put_status(401)
          |> json(%{ error: true, messages: [reason] })
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
        conn
          |> UserSesion.init_user_session(user)
          |> redirect(to: "/home/#{user.email}")
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
