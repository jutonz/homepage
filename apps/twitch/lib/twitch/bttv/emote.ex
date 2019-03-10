defmodule Twitch.Bttv.Emote do
  alias Twitch.Bttv
  defstruct ~w(channel code id image_type regex)a

  @type t :: %Bttv.Emote{
          channel: String.t(),
          code: String.t(),
          id: String.t(),
          image_type: String.t(),
          regex: Regex.t()
        }

  @spec from_bttv_json(Map.t()) :: Bttv.Emote.t()
  def from_bttv_json(json) do
    %Bttv.Emote{
      channel: json["channel"],
      code: json["code"],
      id: json["id"],
      image_type: json["imageType"],
      regex: json["code"] |> Regex.escape() |> Regex.compile!()
    }
  end

  @spec detect(emote :: Bttv.Emote.t(), String.t()) :: non_neg_integer()
  def detect(emote = %Bttv.Emote{}, chat_string) do
    emote.regex
    |> Regex.scan(chat_string)
    |> length()
  end

  @spec detect_many(list(Bttv.Emote.t()), String.t()) :: %{
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
