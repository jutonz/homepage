defmodule Twitch.Api.Streamelements do
  def extension(channel_id, cached_extensions \\ nil) do
    extensions =
      if cached_extensions do
        cached_extensions
      else
        Twitch.Api.extensions(channel_id)
      end

    extensions
    |> Map.get("installed_extensions")
    |> Enum.find(fn extension ->
      extension["extension"]["name"] == "StreamElements Leaderboards"
    end)
  end

  @spec jwt(String.t()) :: String.t()
  def jwt(channel_name) do
    channel_id = Twitch.Api.channel(channel_name)["_id"]
    extensions = Twitch.Api.extensions(channel_id)
    extension = extension(channel_id, extensions)
    extension_id = extension["extension"]["id"]

    extensions
    |> Map.get("tokens")
    |> Enum.find(&(&1["extension_id"] == extension_id))
    |> Map.get("token")
  end
end
