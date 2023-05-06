defmodule ClientWeb.Api.SessionController do
  use ClientWeb, :controller
  alias Client.{Auth, Session}

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

  def exchange(conn, %{"token" => token} = params) do
    case conn |> Session.exchange(token) do
      {:ok, _user, conn} ->
        path = params["to"] || "/#/"
        redirect(conn, to: path)

      {:error, reason} ->
        conn
        |> put_status(401)
        |> json(%{error: true, messages: [reason]})
    end
  end

  def logout(conn, _params) do
    with {:ok, conn} <- Session.logout(conn) do
      redirect(conn, to: "/")
    end
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

    json(conn, response)
  end

  def one_time_login_link(conn, params) do
    with user_id <- conn.assigns[:current_user_id],
         {:ok, jwt, _claims} <- Auth.single_use_jwt(user_id) do
      url = "#{ClientWeb.Endpoint.url()}/api/exchange?token=#{jwt}"

      url =
        if params["to"] do
          url <> "&to=#{params["to"]}"
        else
          url
        end

      response = %{url: url}
      json(conn, response)
    end
  end
end
