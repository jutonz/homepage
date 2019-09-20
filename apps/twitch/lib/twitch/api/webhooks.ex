defmodule Twitch.Api.Webhooks do
  alias Twitch.Api

  def subscribe(topic, lease_seconds \\ 0) do
    path = "helix/webhooks/hub"
    #body = [
      #{"hub.mode", "subscribe"},
      #{"hub.topic", topic},
      #{"hub.lease_seconds", lease_seconds},
      #{"hub.secret", secret()},
      #{"hub.callback", callback()}
    #] |> Poison.encode!()
    body = %{
      "hub.mode" => "subscribe",
      "hub.topic" => topic,
      "hub.lease_seconds" => lease_seconds,
      "hub.secret" => secret(),
      "hub.callback" => callback()
    } |> Poison.encode!()

    Api.Kraken.connection(:post, path, [
      {:body, body},
      {:headers, [{"content-type", "application/json"}]}
    ])
  end

  def unsubscribe(topic) do
  end

  defp secret, do: "sekret"
  defp callback, do: "https://app.jutonz.com"
end
