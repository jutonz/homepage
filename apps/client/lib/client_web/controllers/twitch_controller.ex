defmodule ClientWeb.TwitchController do
  use ClientWeb, :controller

  plug :put_view, ClientWeb.TwitchView

  def login(conn, _params) do
    {:ok, authorize_url} = Twitch.Auth.authorize_url()
    conn |> redirect(external: authorize_url)
  end

  def exchange(conn, %{"code" => code} = _params) do
    {:ok, access_token} = Twitch.Auth.exchange(code)

    conn = conn |> fetch_session
    current_user_id = conn |> get_session(:user_id)

    {:ok, user} = Twitch.User.login_from_twitch(current_user_id, access_token)

    IO.inspect(user)

    conn
    |> put_session(:twitch_token, access_token)
    |> redirect(to: "/#/twitch?justintegrated=yep")
  end

  def failurelog(conn, _params) do
    log = Twitch.EventParseFailureLogger.get_log() |> Enum.join("\n")

    conn
    |> put_resp_header("content-type", "text/plain")
    |> send_resp(200, log)
  end
end
