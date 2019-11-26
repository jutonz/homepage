defmodule ClientWeb.Plugs.BrowserAuthenticated do
  def init(opts), do: opts

  def call(conn, _opts) do
    case Client.Session.check_session(conn) do
      {:error, _reason} ->
        path = conn.request_path

        conn
        |> Phoenix.Controller.redirect(to: "/#/login?to=#{path}")
        |> Plug.Conn.halt()

      {:ok, _user_id} ->
        conn
    end
  end
end
