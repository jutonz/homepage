defmodule Twitch.TwitchEmotes do
  alias Twitch.TwitchEmotes

  @spec emote(String.t()) :: Twitch.Emote.t()
  def emote(emote_id), do: [emote_id] |> emotes() |> hd()

  @spec emotes(list(String.t())) :: list(Twitch.Emote.t())
  def emotes(emote_ids) do
    path = "/api/v4/emotes"
    params = [{"id", Enum.join(emote_ids, ",")}]

    :get
    |> TwitchEmotes.Api.connection(path, params: params)
    |> Enum.map(&Twitch.Emote.from_twitch_json/1)
  end
end
