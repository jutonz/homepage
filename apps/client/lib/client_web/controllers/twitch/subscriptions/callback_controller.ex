defmodule ClientWeb.Twitch.Subscriptions.CallbackController do
  use ClientWeb, :controller
  alias Twitch.WebhookSubscriptions

  # Called to verify the intent of the subscriber
  # https://www.w3.org/TR/websub/#x5-3-hub-verifies-intent-of-the-subscriber
  def show(conn, params) do
    %{
      "hub.topic" => topic,
      "hub.challenge" => challenge,
      "id" => user_id
    } = params

    case WebhookSubscriptions.get_by_topic(user_id, topic) do
      nil ->
        send_resp(conn, 404, "")

      sub ->
        {:ok, _updated} = WebhookSubscriptions.confirm(sub)
        send_resp(conn, 200, challenge)
    end
  end

  # Called with a webhook event
  def create(conn, params) do
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
