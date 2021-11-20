defmodule ClientWeb.Twitch.Subscriptions.CallbackController do
  # Started with OTP 24 and Elixir 1.12
  @dialyzer {:no_return, callback: 2}

  use ClientWeb, :controller
  alias Twitch.Eventsub.Subscriptions

  plug ClientWeb.Plugs.VerifyTwitchCallback

  def callback(conn, params) do
    [event_type] = get_req_header(conn, "twitch-eventsub-message-type")

    case event_type do
      "webhook_callback_verification" ->
        send_resp(conn, 200, params["challenge"])
      "notification" ->
        params["id"]
        |> Subscriptions.get()
        |> Subscriptions.callback(params)

        send_resp(conn, 204, "")
      "revocation" ->
        params["id"]
        |> Subscriptions.get()
        |> Subscriptions.destroy()
        send_resp(conn, 204, "")
      _ ->
        send_resp(conn, 404, "")
    end
  end
end
