defmodule Twitch.Eventpub.Subscriptions.MakeRequest do
  @behaviour Twitch.Util.Interactible

  @type options :: %{
    type: String.t(),
    condition: map() | nil,
    version: non_neg_integer()
  }

  @spec up(map(), options()) :: {:ok, any()} | {:error | any()}
  def up(context, [options]) do
    options
    |> to_body()
    |> Twitch.Api.Eventsub.Subscriptions.create()
    |> Twitch.ApiClient.make_request()
    |> case do
      {:ok, response} ->
        {:ok, %{context | response: response}}

      {:error, response} ->
        {:error, %{context | response: response}}
    end
  end

  def down(context, _response) do
    # TODO: Delete subscription on twitch
    {:ok, context}
  end

  defp to_body(options) do
    %{
      "type" => options[:type],
      "condition" => options[:condition],
      "version" => options[:version],
      "transport" => transport()
    }
  end

  defp transport do
    %{
      "method" => "webhook",
      "callback" => "",
      "secret" => ""
    }
  end
end
