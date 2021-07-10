defmodule Twitch.WebhookSubscriptions.Signing do
  # Started with OTP 24 and Elixir 1.12
  @dialyzer {:no_return, signature: 1}

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
