defmodule ClientWeb.Twitch.Subscriptions.CallbackController do
  # Started with OTP 24 and Elixir 1.12
  @dialyzer {:no_return, callback: 2}

  use ClientWeb, :controller

  alias Twitch.Eventsub.Subscriptions

  def callback(conn, params) do
    #raw_body = conn.assigns[:raw_body] |> hd()
    #IO.inspect(conn.resp_headers)
    #IO.inspect(params)
    # TODO: Convert verification into a plug?
    #calc_sig = Subscriptions.calculate_signature(
      #hd(get_req_header(conn, "twitch-eventsub-message-id"))
        #<> hd(get_req_header(conn, "twitch-eventsub-message-timestamp"))
        #<> raw_body
    #)
    #actual_sig =
      #conn
      #|> get_req_header("twitch-eventsub-message-signature")
      #|> hd()

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
    end

    #if calc_sig == actual_sig do
      #send_resp(conn, 202, "")
    #else
      #send_resp(conn, 400, "")
    #end
  end

  def log(conn, _params) do
    messages = Twitch.WebhookSubscriptions.Log.get_log()
    IO.inspect(messages)
    json = Poison.encode!(%{messages: messages})

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, json)
  end
end
