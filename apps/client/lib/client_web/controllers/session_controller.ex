defmodule ClientWeb.SessionController do
  use ClientWeb, :controller
  alias Client.SessionServer

  def login(conn, %{ "email" => email, "password" => password }) do
    case conn |> SessionServer.login(email, password) do
      {:ok, _user, conn} ->
        conn |> put_status(200) |> json(%{ error: false })
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

  def signup(conn, %{ "email" => email, "password" => password }) do
    case conn |> SessionServer.signup(email, password) do
      {:ok, _user, conn} -> conn |> put_status(200) |> json(%{ error: false })
      {:error, reason} ->
        conn
          |> put_flash(:error, "Failed to signup: #{reason}")
          |> render(:signup)
    end
  end
end
