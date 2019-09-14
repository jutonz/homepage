defmodule ClientWeb.Plugs.BrowserAuthenticated do
  def init(opts), do: opts

  def call(conn, _opts) do
    case Client.Session.check_session(conn) do
      {:error, _reason} ->
        path = conn.request_path
        Phoenix.Controller.redirect(conn, to: "/#/login?to=#{path}")

      {:ok, _user_id} ->
        conn
    end
  end
end
