defmodule Twitch.WebhookSubscriptions.Signing do
  def signature(body) do
    signature =
      :sha256
      |> :crypto.hash([signing_secret(), body])
      |> Base.encode16()

    "sha256=" <> signature
  end

  defp signing_secret do
    Application.get_env(:twitch, :webhook_secret)
  end
end
