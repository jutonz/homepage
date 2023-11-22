defmodule Twitch.SevenTv.Emote do
  defstruct ~w(id name regex)a

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          regex: Regex.t()
        }

  def from_json(json) do
    %__MODULE__{
      id: json["id"],
      name: json["name"],
      regex: json["name"] |> Regex.escape() |> Regex.compile!()
    }
  end

  @spec detect(emote :: t(), String.t()) :: non_neg_integer()
  def detect(emote = %__MODULE__{}, chat_string) do
    emote.regex
    |> Regex.scan(chat_string)
    |> length()
  end

  @spec detect_many(list(t()), String.t()) :: %{
          optional(String.t()) => non_neg_integer()
        }
  def detect_many(emotes, chat_string) do
    emotes
    |> Enum.map(fn emote ->
      {emote, detect(emote, chat_string)}
    end)
    |> Enum.reduce(%{}, fn {emote, count}, result ->
      if count > 0 do
        result |> Map.put(emote.name, count)
      else
        result
      end
    end)
  end
end
