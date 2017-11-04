defmodule HomepageWeb.Helpers.UserSession do
  import Plug.Conn

  def logout(conn) do
    conn
    |> put_session(:user_id, nil)
    |> assign(:current_user, nil)
  end

  def current_user(conn) do
    conn.assigns[:current_user] || load_current_user(conn)
  end

  defp load_current_user(conn) do
    user_id = get_session conn, :user_id
    if user_id do
      Homepage.Repo.get Homepage.User, user_id
    end
  end

  ##
  # This is a plug.
  #
  # If user is authenticated, do nothing. Otherwise redirect to /login.
  def load_user_or_redirect(conn, _options) do
    if current_user(conn) == nil do
      conn
        |> Phoenix.Controller.put_flash(:error, "Please login")
        |> Phoenix.Controller.redirect(to: "/login")
    end

    conn
  end
end
