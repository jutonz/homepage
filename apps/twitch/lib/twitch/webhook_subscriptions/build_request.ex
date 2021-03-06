defmodule Twitch.WebhookSubscriptions.BuildRequest do
  @behaviour Twitch.Util.Interactible

  alias Twitch.WebhookSubscriptions.Subscription
  alias Twitch.WebhookSubscriptions.SubscriptionRequest
  alias Twitch.WebhookSubscriptions.Topic

  def up(%Twitch.Channel{} = channel, mode \\ :subscribe) do
    request = %SubscriptionRequest{
      mode: mode,
      topic: Topic.topic(channel),
      lease_seconds: 864_000,
      secret: Subscription.secret(),
      callback: Subscription.callback(channel.user_id),
      user_id: channel.user_id
    }

    {:ok, request}
  end

  def down(data), do: {:ok, data}
end
