defmodule Twitch.TwitchEmotes do
  @spec emote(String.t()) :: Twitch.Emote.t()
  def emote(emote_id) do
    case emotes([emote_id]) do
      [] -> nil
      [emote] -> emote
    end
  end

  @spec emotes(list(String.t())) :: list(Twitch.Emote.t())
  def emotes(emote_ids) do
    path = "/api/v4/emotes"
    params = [{"id", Enum.join(emote_ids, ",")}]

    :get
    |> client().connection(path, params: params)
    |> Enum.map(&Twitch.Emote.from_twitch_json/1)
  end

  def client, do: Application.get_env(:twitch, :twitch_emotes_api_client)
end
