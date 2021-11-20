defmodule Twitch.WebhookSubscriptions.MakeRequest do
  @behaviour Twitch.Util.Interactible

  require Logger
  alias Twitch.WebhookSubscriptions.SubscriptionRequest

  def up(%Twitch.Api.Request{} = request) do
    Twitch.ApiClient.make_request(request)
  end

  def down(%SubscriptionRequest{} = request) do
    unsub_request = Map.put(request, :mode, "unsubscribe")

    case SubscriptionRequest.perform(unsub_request) do
      :ok ->
        {:ok, unsub_request}

      {:error, reason} ->
        message = "Failed to unsubscribe from twitch webhook: #{reason}"
        Logger.info(message)
        Sentry.capture_message(message, extra: unsub_request)
        {:ok, unsub_request}
    end
  end
end
