defmodule Twitch.Eventsub.Subscriptions.MakeRequest do
  @behaviour Twitch.Util.Interactible

  alias Twitch.Eventsub.Subscription

  @type options :: %{
          type: String.t(),
          condition: map() | nil,
          version: non_neg_integer()
        }

  @spec up(map(), [options()]) :: {:ok, any()} | {:error, any()}
  def up(context, [options]) do
    {status, response} =
      context
      |> to_body(options)
      |> Twitch.Api.Eventsub.Subscriptions.create()
      |> Twitch.ApiClient.make_request()

    {status, Map.put(context, :response, response)}
  end

  def down(context, _response) do
    # TODO: Delete subscription on twitch
    {:ok, context}
  end

  defp to_body(context, options) do
    %{
      "type" => options[:type],
      "condition" => options[:condition],
      "version" => options[:version],
      "transport" => transport(context)
    }
  end

  defp transport(%{subscription: sub}) do
    %{
      "method" => "webhook",
      "callback" => Subscription.callback(sub),
      "secret" => Application.get_env(:twitch, :webhook_secret)
    }
  end
end
