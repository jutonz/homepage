defmodule Twitch.WebhookSubscriptions.Signing do
  def signature(body) do
    signature =
      :sha256
      |> :crypto.mac(:hmac, secret(), body)
      |> Base.encode16()
      |> String.downcase()

    "sha256=" <> signature
  end

  defp secret do
    Application.get_env(:twitch, :webhook_secret)
  end
end
