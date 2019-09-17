defmodule ClientWeb.Settings.Api.TokenController do
  use ClientWeb, :controller
  alias Client.ApiTokens

  def new(conn, _params) do
    changeset = ApiTokens.new_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"api_token" => token_params}) do
    insert_result =
      token_params
      |> Map.put("user_id", Client.Session.current_user_id(conn))
      |> ApiTokens.create()

    case insert_result do
      {:ok, token} ->
        conn
        |> put_flash(:success, "Created!")
        |> redirect(to: settings_api_path(ClientWeb.Endpoint, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:danger, "Unable to create token")
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case ApiTokens.delete(id) do
      {:ok, _token} ->
        redirect(conn, to: settings_api_path(ClientWeb.Endpoint, :index))

      {:error, _changeset} ->
        conn
        |> put_flash(:danger, "Failed to delete")
        |> redirect(to: settings_api_path(ClientWeb.Endpoint, :index))
    end
  end
end
