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

  def token_test(conn, _params) do
    api_token = conn.assigns[:api_token]
    current_user = Client.Repo.get(Client.User, api_token.user_id)
    response = %{
      current_user: %{
        email: current_user.email
      },
      token: %{
        description: api_token.description
      }
    }

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(response))
  end
end
