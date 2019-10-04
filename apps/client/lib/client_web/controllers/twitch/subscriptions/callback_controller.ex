defmodule ClientWeb.Twitch.Subscriptions.CallbackController do
  use ClientWeb, :controller

  def test(conn, _params) do
    send_resp(conn, 200, "")
  end

  def callback(conn, params) do
    {:ok, body, conn} = read_body(conn)
    signature = get_req_header(conn, "X-Hub-Signature")
    signing_secret = Application.get_env(:twitch, :webhook_secret)
    calc_sig = :crypto.hash(:sha256, [signing_secret, body])

    Twitch.WebhookSubscriptions.Log.log(%{
      actual_signature: signature,
      calculated_signature: calc_sig,
      response: params
    })

    send_resp(conn, 202, "")
  end

  def log(conn, _params) do
    messages = Twitch.WebhookSubscriptions.Log.get_log()
    json = Poison.encode!(%{messages: messages})

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, json)
  end
end
