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
end
