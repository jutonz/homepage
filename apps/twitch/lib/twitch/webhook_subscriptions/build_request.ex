defmodule Twitch.WebhookSubscriptions.BuildRequest do
  @behaviour Twitch.Util.Interactible

  alias Twitch.WebhookSubscriptions.Subscription
  #alias Twitch.WebhookSubscriptions.SubscriptionRequest
  #alias Twitch.WebhookSubscriptions.Topic

  @type mode :: :subscribe | :unsubscribe

  @spec up(Twitch.Channel.t(), mode()) :: {:ok, map()} | {:error, any()}
  def up(channel, mode \\ :subscribe)

  def up(channel, :subscribe) do
    ela_user_id = "26921830"
    request = Twitch.Api.Eventsub.Subscriptions.create(%{
      "type" => "channel.update",
      "condition" => %{"broadcaster_user_id" => ela_user_id},
      "version" => 1,
      "transport" => %{
        "method" => "webhook",
        "callback" => Subscription.callback(channel.user_id),
        "secret" => Subscription.secret()
      }
    })

    #request = %SubscriptionRequest{
      #mode: mode,
      #topic: Topic.topic(channel),
      #lease_seconds: 864_000,
      #secret: Subscription.secret(),
      #callback: Subscription.callback(channel.user_id),
      #user_id: channel.user_id
    #}

    {:ok, request}
  end

  def up(_channel, :unsubscribe) do
    # TODO
    {:error, :not_implemented}
  end

  def down(data), do: {:ok, data}
end
