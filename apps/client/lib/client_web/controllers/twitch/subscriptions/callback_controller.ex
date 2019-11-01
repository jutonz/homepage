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

  def callback(conn, %{"id" => sub_id}) do
    raw_body = conn.assigns[:raw_body] |> hd()
    signature = conn |> get_req_header("x-hub-signature") |> hd()

    with :ok <- WebhookSubscriptions.verify_signature(raw_body, signature),
         sub when is_map(sub) <- WebhookSubscriptions.get(sub_id),
         {:ok, _callback} <- WebhookSubscriptions.create_callback(sub, conn.body_params) do
      send_resp(conn, 202, "")
    else
      :invalid_signature ->
        Twitch.WebhookSubscriptions.Log.log(%{
          actual_signature: signature,
          raw_body: raw_body,
          body_byte_size: byte_size(raw_body),
          content_length: conn |> get_req_header("content-length") |> hd() |> String.to_integer()
        })

        send_resp(conn, 400, "")

      _ ->
        send_resp(conn, 400, "")
    end
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
