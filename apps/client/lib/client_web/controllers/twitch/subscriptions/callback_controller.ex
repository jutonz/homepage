defmodule ClientWeb.Twitch.Subscriptions.CallbackController do
  use ClientWeb, :controller
  alias Twitch.WebhookSubscriptions

  # Called to verify the intent of the subscriber
  # https://www.w3.org/TR/websub/#x5-3-hub-verifies-intent-of-the-subscriber
  def confirm(conn, params) do
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

  def callback(conn, _params) do
    raw_body = conn.assigns[:raw_body] |> hd()
    IO.inspect(raw_body)
    signature = conn |> get_req_header("x-hub-signature") |> hd()
    calc_sig = WebhookSubscriptions.calculate_signature(raw_body)

    Twitch.WebhookSubscriptions.Log.log(%{
      actual_signature: signature,
      calculated_signature: calc_sig,
      raw_body: raw_body
    })

    send_resp(conn, 202, "")
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
