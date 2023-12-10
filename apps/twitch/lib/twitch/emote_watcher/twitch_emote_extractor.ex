defmodule Twitch.EmoteWatcher.TwitchEmoteExtractor do
  alias Twitch.ParsedEvent

  def extract(%ParsedEvent{tags: nil}), do: []
  def extract(%ParsedEvent{tags: %{"emotes" => ""}}), do: []

  def extract(%ParsedEvent{tags: %{"emotes" => emotes}}) do
    emotes
    |> String.split("/")
    |> Stream.map(fn emote -> emote |> String.split(":") |> hd() end)
    |> Stream.map(&Twitch.TwitchEmotes.emote/1)
    |> reject_nil()
  end

  # defp to_emote_struct(emote_id) do
    # Twitch.Emote.from_twitch_json
  # end

  defp reject_nil(collection) do
    Enum.reduce(collection, [], fn elem, acc ->
      if elem do
        [elem | acc]
      else
        acc
      end
    end)
  end
end
