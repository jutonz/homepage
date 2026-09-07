defmodule ClientWeb.Settings.TokenController do
  use ClientWeb, :controller
  alias Client.ApiTokens

  def new(conn, _params) do
    changeset = ApiTokens.new_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"api_token" => token_params}) do
    case ApiTokens.create(conn.assigns.scope, token_params) do
      {:ok, _token} ->
        conn
        |> put_flash(:success, "Created!")
        |> redirect(to: Routes.settings_api_path(ClientWeb.Endpoint, :show))

      {:error, changeset} ->
        conn
        |> put_flash(:danger, "Unable to create token")
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case ApiTokens.delete(conn.assigns.scope, id) do
      {:ok, _token} ->
        redirect(conn, to: Routes.settings_api_path(ClientWeb.Endpoint, :show))

      {:error, _changeset} ->
        conn
        |> put_flash(:danger, "Failed to delete")
        |> redirect(to: Routes.settings_api_path(ClientWeb.Endpoint, :show))
    end
  end
end
