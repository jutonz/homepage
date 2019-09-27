defmodule Twitch.WebhookSubscriptions.BuildRequest do
  @behaviour Client.Util.Interactible

  alias Twitch.WebhookSubscriptions.Subscription
  alias Twitch.WebhookSubscriptions.SubscriptionRequest
  alias Twitch.WebhookSubscriptions.Topic

  def up(%Twitch.Channel{} = channel, mode \\ :subscribe) do
    request = %SubscriptionRequest{
      mode: mode,
      topic: Topic.topic(channel),
      lease_seconds: 864000,
      secret: Subscription.gen_secret(),
      callback: Subscription.callback(),
      user_id: channel.user_id
    }

    {:ok, request}
  end

  def down(data), do: {:ok, data}
end
