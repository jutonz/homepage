defmodule Twitch.WebhookSubscriptions.PersistWebhook do
  @behaviour Twitch.Util.Interactible

  alias Twitch.WebhookSubscriptions
  alias Twitch.WebhookSubscriptions.SubscriptionRequest

  def up(%SubscriptionRequest{} = request) do
    params = %{
      topic: request.topic,
      secret: request.secret,
      expires_at: time_in(request.lease_seconds),
      user_id: request.user_id
    }

    WebhookSubscriptions.create(params)
  end

  def down(%SubscriptionRequest{} = request) do
    case WebhookSubscriptions.get_by_topic(request.user_id, request.topic) do
      nil -> {:ok, request}
      sub -> WebhookSubscriptions.delete(sub)
    end
  end

  @buffer 30
  defp time_in(seconds) do
    now = DateTime.utc_now()
    DateTime.add(now, seconds - @buffer, :second)
  end
end
