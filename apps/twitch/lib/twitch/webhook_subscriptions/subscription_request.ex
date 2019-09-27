defmodule Twitch.WebhookSubscriptions.SubscriptionRequest do
  alias Twitch.WebhookSubscriptions.SubscriptionRequest

  defstruct ~w[
    mode
    topic
    lease_seconds
    secret
    callback
    user_id
  ]a

  def perform(%SubscriptionRequest{} = request) do
    request_body = %{
      "hub.mode" => request.mode,
      "hub.topic" => request.topic,
      "hub.lease_seconds" => request.lease_seconds,
      "hub.secret" => request.secret,
      "hub.callback" => request.callback
    }

    case Twitch.Api.Webhooks.call(request_body) do
      "" -> :ok
      error -> {:error, error}
    end
  end
end
