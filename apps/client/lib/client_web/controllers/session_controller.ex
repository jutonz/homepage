defmodule ClientWeb.SessionController do
  use ClientWeb, :controller
  alias Client.Session

  def login(conn, %{"email" => email, "password" => password}) do
    case conn |> Session.login(email, password) do
      {:ok, _user, conn} ->
        conn |> put_status(200) |> json(%{error: false})

      {:error, reason} ->
        conn
        |> put_status(401)
        |> json(%{error: true, messages: [reason]})
    end
  end

  def exchange(conn, %{"token" => token}) do
    case conn |> Session.exchange(token) do
      {:ok, _user, conn} ->
        conn |> redirect(to: "/#/")

      {:error, reason} ->
        conn
        |> put_status(401)
        |> json(%{error: true, messages: [reason]})
    end
  end

  def logout(conn, _params) do
    with {:ok, conn} <- Session.logout(conn), do: redirect(conn, to: "/")
  end
end
