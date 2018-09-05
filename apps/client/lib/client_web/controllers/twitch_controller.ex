defmodule ClientWeb.TwitchController do
  use ClientWeb, :controller

  def login(conn, _params) do
    {:ok, authorize_url} = Twitch.Auth.authorize_url()
    conn |> redirect(external: authorize_url)
  end

  def exchange(conn, %{"code" => code} = _params) do
    {:ok, token} = Twitch.Auth.exchange(code)

    IO.puts "token: #{token}"

    #Twitch.Application.subscribe_to_channel("#sodapopin", token)

    conn
    |> fetch_session()
    |> put_session(:twitch_token, token)
    |> redirect(to: "/#/twitch")
  end
end
