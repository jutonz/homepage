defmodule HomepageWeb.SessionController do
  use HomepageWeb, :controller
  alias Homepage.User
  alias HomepageWeb.Helpers.UserSession
  alias Homepage.Servers.SessionServer

  def show_login(conn, _params) do
    # If already logged in, send to /home
    case conn |> SessionServer.current_user do
      user = %User{} -> conn |> redirect(to: "/home")
      _ -> conn |> render(:login)
    end
  end

  def login(conn, %{ "email" => email, "password" => password }) do
    case conn |> SessionServer.login(email, password) do
      {:ok, user, conn} ->
        conn |> redirect(to: "/home")
      {:error, reason} ->
        conn
          |> put_status(401)
          |> json(%{ error: true, messages: [reason] })
    end
  end

  def logout(conn, _params) do
    with {:ok, conn} <- SessionServer.logout(conn),
      do: redirect(conn, to: "/")
  end

  def show_signup(conn, _params) do
    conn
      |> clear_flash
      |> render(:signup)
  end

  def signup(conn, %{ "email" => email, "password" => password }) do
    case conn |> SessionServer.signup(email, password) do
      {:ok, user, conn} -> conn |> redirect(to: "/home")
      {:error, reason} ->
        conn
          |> put_flash(:error, "Failed to signup: #{reason}")
          |> render(:signup)
    end
  end
end
