defmodule Twitch.Bttv do
  alias Twitch.Bttv

  def channel_emotes(channel_name) do
    Bttv.Api.connection(:get, "channels/#{channel_name}")
    |> Map.get("emotes")
    |> Enum.map(&Bttv.Emote.from_bttv_json/1)
  end

  def global_emotes do
    Bttv.Api.connection(:get, "emotes")
    |> Map.get("emotes")
    |> Enum.map(&Bttv.Emote.from_bttv_json/1)
  end

  def global_ffz_emotes do
    Bttv.Api.connection(:get, "frankerfacez_emotes/global")
    |> Map.get("emotes")
    |> Enum.map(&Bttv.Emote.from_bttv_json/1)
  end

  def channel_ffz_emotes(channel_id) do
    Bttv.Api.connection(:get, "frankerfacez_emotes/channels/#{channel_id}")
    |> Map.get("emotes")
    |> Enum.map(&Bttv.Emote.from_bttv_json/1)
  end
end
