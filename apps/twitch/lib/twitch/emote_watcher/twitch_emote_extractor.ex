defmodule Twitch.EmoteWatcher.TwitchEmoteExtractor do
  alias Twitch.ParsedEvent

  def extract(%ParsedEvent{tags: nil}), do: []
  def extract(%ParsedEvent{tags: %{"emotes" => ""}}), do: []

  def extract(%ParsedEvent{tags: %{"emotes" => emotes}} = event) do
    emotes
    |> String.split("/")
    |> Stream.map(&to_emote_struct(event, &1))
    |> reject_nil()
  end

  def extract(%ParsedEvent{tags: %{}}), do: []

  # emote_str looks like emote_id:pos_start-pos_end, e.g. 1:0-5
  defp to_emote_struct(%ParsedEvent{message: message}, emote_str) do
    match =
      Regex.named_captures(
        ~r/(?<emote_id>.*)\:(?<pos_begin>\d*)-(?<pos_end>\d*)/,
        emote_str
      )

    case match do
      %{
        "emote_id" => id,
        "pos_begin" => pos_begin,
        "pos_end" => pos_end
      } ->
        pos_begin = String.to_integer(pos_begin)
        pos_end = String.to_integer(pos_end)
        code = String.slice(message, pos_begin..pos_end)

        Twitch.Emote.from_twitch_json(%{"id" => id, "code" => code})

      _ ->
        nil
    end
  end

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
