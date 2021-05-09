defmodule Twitch.Bttv do
  alias Twitch.Bttv

  def channel_emotes(channel_name) do
    emotes = Bttv.Api.connection(:get, "cached/users/twitch/#{channel_name}")
    channel_emotes = emotes["channelEmotes"]
    shared_emotes = emotes["sharedEmotes"]

    (channel_emotes ++ shared_emotes)
    |> Enum.map(&Bttv.Emote.from_bttv_json/1)
  end

  def global_emotes do
    Bttv.Api.connection(:get, "cached/emotes/global")
    |> Enum.map(&Bttv.Emote.from_bttv_json/1)
  end

  def global_ffz_emotes do
    Bttv.Api.connection(:get, "cached/frankerfacez/emotes/global")
    |> Enum.map(&Bttv.Emote.from_bttv_json/1)
  end

  def channel_ffz_emotes(channel_id) do
    path = "cached/frankerfacez/users/twitch/#{channel_id}"

    client().connection(:get, path)
    |> Enum.map(&Bttv.Emote.from_bttv_json/1)
  end

  def client, do: Application.get_env(:twitch, :bttv_api_client)
end
