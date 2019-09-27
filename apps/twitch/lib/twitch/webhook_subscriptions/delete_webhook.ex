defmodule Twitch.WebhookSubscriptions.DeleteWebhook do
  @behaviour Twitch.Util.Interactible

  alias Twitch.WebhookSubscriptions
  alias Twitch.WebhookSubscriptions.SubscriptionRequest

  def up(%SubscriptionRequest{} = request) do
    request.user_id
    |> WebhookSubscriptions.get_by_topic(request.topic)
    |> WebhookSubscriptions.delete()
  end

  def down(data), do: {:ok, data}
end
