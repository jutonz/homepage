defmodule Twitch.Eventsub.Subscriptions.EnsureSubscription do
  require Logger

  alias Twitch.{
    Eventsub.Subscriptions
  }

  def call(subscription_config) do
    case Subscriptions.get_by_config(subscription_config) do
      nil -> Subscriptions.create(subscription_config)
      sub -> check_existing_subscription(sub)
    end
  end

  defp check_existing_subscription(%{twitch_id: nil} = sub) do
    recreate(sub)
  end

  defp check_existing_subscription(%{twitch_id: twitch_id} = sub) do
    case get_remote_subscription_status(twitch_id) do
      "enabled" ->
        sub

      other ->
        Logger.warning(
          "Existing twitch eventsub subscription had bad status \"#{other}\"; recreating"
        )

        recreate(sub)
    end
  end

  defp recreate(sub) do
    create_params = %{
      type: sub.type,
      condition: sub.condition,
      version: sub.version
    }

    with {:ok, _sub} <- Subscriptions.destroy(sub),
         {:ok, sub} <- Subscriptions.create(create_params) do
      sub
    end
  end

  defp get_remote_subscription_status(twitch_id) do
    with {:ok, %{data: data}} <- Twitch.Api.get_eventsub_subscription(twitch_id),
         %{"data" => [data]} <- data do
      data["status"]
    else
      _ -> nil
    end
  end
end
