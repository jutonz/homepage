defmodule Twitch.Emote do
  @derive {JSON.Encoder, only: ~w[id code]a}

  defstruct ~w(id code regex)a

  @type t :: %Twitch.Emote{
          id: String.t(),
          code: String.t(),
          regex: Regex.t()
        }

  @spec from_twitch_json(map) :: Twitch.Emote.t()
  def from_twitch_json(json) do
    %Twitch.Emote{
      id: json["id"],
      code: json["code"],
      regex: json["code"] |> Regex.escape() |> Regex.compile!()
    }
  end

  @spec detect(emote :: Twitch.Emote.t(), String.t()) :: non_neg_integer()
  def detect(emote = %Twitch.Emote{}, chat_string) do
    emote.regex
    |> Regex.scan(chat_string)
    |> length()
  end

  @spec detect_many(list(Twitch.Emote.t()), String.t()) :: %{
          optional(String.t()) => non_neg_integer()
        }
  def detect_many(emotes, chat_string) do
    emotes
    |> Enum.map(fn emote ->
      {emote, detect(emote, chat_string)}
    end)
    |> Enum.reduce(%{}, fn {emote, count}, result ->
      if count > 0 do
        result |> Map.put(emote.code, count)
      else
        result
      end
    end)
  end
end
