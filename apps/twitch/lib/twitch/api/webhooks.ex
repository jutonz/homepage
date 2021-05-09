defmodule Twitch.Api.Webhooks do
  alias Twitch.Api

  def call(body) do
    path = "helix/webhooks/hub"
    json = Poison.encode!(body)

    headers = [
      {"content-type", "application/json"},
      {"client-id", client_id()}
    ]

    Api.Kraken.connection(:post, path, [
      {:body, json},
      {:headers, headers}
    ])
  end

  defp client_id do
    System.get_env("TWITCH_CLIENT_ID")
  end
end
