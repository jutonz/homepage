defmodule Twitch.EmoteWatcher.TwitchEmoteExtractor do
  alias Twitch.ParsedEvent

  def extract(%ParsedEvent{tags: nil}), do: []
  def extract(%ParsedEvent{tags: %{"emotes" => ""}}), do: []

  def extract(%ParsedEvent{tags: %{"emotes" => emotes}}) do
    emotes
    |> String.split("/")
    |> Stream.map(fn emote -> emote |> String.split(":") |> hd() end)
    |> Enum.reduce([], fn emote, emotes ->
      if emote do
        [emote | emotes]
      else
        emotes
      end
    end)
    |> Enum.map(&Twitch.TwitchEmotes.emote/1)
  end
end
