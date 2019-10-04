defmodule Twitch.Api.Webhooks do
  alias Twitch.Api

  def call(body) do
    path = "helix/webhooks/hub"
    json = Poison.encode!(body)

    Api.Kraken.connection(:post, path, [
      {:body, json},
      {:headers, [{"content-type", "application/json"}]}
    ])
  end
end
