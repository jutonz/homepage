defmodule Twitch.Api.Streamelements do
  def extension(twitch_user, channel_id, cached_extensions \\ nil) do
    extensions =
      if cached_extensions do
        cached_extensions
      else
        Twitch.Api.extensions(
          access_token_from_user(twitch_user),
          channel_id
        )
      end

    extensions
    |> Map.get("installed_extensions")
    |> Enum.find(fn extension ->
      extension["extension"]["name"] == "StreamElements Leaderboards"
    end)
  end

  @spec jwt(Twitch.User.t(), String.t()) :: {:ok, String.t()} | {:ok, :not_enabled}
  def jwt(twitch_user, channel_name) do
    channel_id = Twitch.Api.user(channel_name)["_id"]
    access_token = access_token_from_user(twitch_user)

    extensions =
      Twitch.Api.extensions(
        access_token,
        channel_id
      )

    extension = extension(twitch_user, channel_id, extensions)

    case extension do
      nil ->
        {:ok, :not_enabled}

      _ ->
        extension_id = extension["extension"]["id"]

        token =
          extensions
          |> Map.get("tokens")
          |> Enum.find(&(&1["extension_id"] == extension_id))
          |> Map.get("token")

        {:ok, token}
    end
  end

  def access_token_from_user(twitch_user) do
    twitch_user.access_token["access_token"]
  end
end
