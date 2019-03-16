defmodule Twitch.Api do
  alias Twitch.{Api, ApiConnection}

  def current_user(access_token) do
    with {:ok, json} <- ApiConnection.connection(access_token, :get, "/helix/users"),
         do:
           (
             %{"data" => [user]} = json
             {:ok, user}
           ),
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to fetch user"}
           )
  end

  def emotes(emote_set_ids \\ []) do
    path = "kraken/chat/emoticon_images"

    params =
      if Enum.empty?(emote_set_ids) do
        nil
      else
        emotesets = emote_set_ids |> Enum.join(",")
        params = [{"emotesets", emotesets}]
      end

    Api.Kraken.connection(:get, path, params: params)
  end

  def channel(channel_name) do
    path = "kraken/channels/#{channel_name}"

    Api.Kraken.connection(:get, path, [
      {:headers, [{"Accept", "application/vnd.twitchtv.v3+json"}]}
    ])
  end

  @spec channel_emotes(String.t(), Integer.t()) :: list(Twitch.Emote.t())
  def channel_emotes(channel_name, tier \\ 3) do
    path = "channels/#{channel_name}/product"

    product_data =
      Twitch.Api.Kraken.connection(:get, path, [
        {:headers, [{"Accept", "application/vnd.twitchtv.v3+json"}]}
      ])

    plan_code = tier |> to_string |> String.pad_trailing(4, "0")

    plan_emote_sets =
      product_data
      |> Map.get("plans")
      |> Enum.find(fn plan -> plan["plan"] == plan_code end)
      |> Map.get("emoticon_set_ids")

    plan_emote_sets
    |> Twitch.Api.emotes()
    |> Map.get("emoticon_sets")
    |> Map.values()
    |> List.flatten()
    |> Enum.map(&Twitch.Emote.from_twitch_json/1)
  end

  def global_emotes() do
    Twitch.Api.emotes(["0"])
    |> Map.get("emoticon_sets")
    |> Map.values()
    |> List.flatten()
    |> Enum.map(&Twitch.Emote.from_twitch_json/1)
  end
end
