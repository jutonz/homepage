defmodule Twitch.WebhookSubscriptions.MakeRequest do
  @behaviour Client.Util.Interactible

  require Logger
  alias Twitch.WebhookSubscriptions.SubscriptionRequest

  def up(%SubscriptionRequest{} = request) do
    case SubscriptionRequest.perform(request) do
      :ok -> {:ok, request}
      {:error, reason} -> {:error, reason}
    end
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
