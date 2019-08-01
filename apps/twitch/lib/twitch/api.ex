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
        [{"emotesets", emotesets}]
      end

    Api.Kraken.connection(:get, path, params: params)
  end

  def channel(channel_name) do
    path = "kraken/channels/#{channel_name}"

    Api.Kraken.connection(:get, path, [
      {:headers, [{"Accept", "application/vnd.twitchtv.v3+json"}]}
    ])
  end

  @type stream_type :: :live | :playlist | :all
  def streams(channel_id, stream_type \\ :live) do
    path = "kraken/streams/#{channel_id}"

    Api.Kraken.connection(:get, path, params: [{"stream_type", to_string(stream_type)}])
  end

  def extensions(auth_token, channel_id) do
    path = "v5/channels/#{channel_id}/extensions"

    Api.Kraken.connection(:get, path, [
      {:headers, [{"Authorization", "Bearer #{auth_token}"}]}
    ])
  end

  @spec channel_emotes(String.t(), Integer.t()) :: list(Twitch.Emote.t())
  def channel_emotes(channel_name, tier \\ 3) do
    path = "channels/#{channel_name}/product"

    product_data =
      Twitch.Api.Kraken.connection(:get, path, [
        {:headers, [{"Accept", "application/vnd.twitchtv.v3+json"}]}
      ])

    case product_data["status"] do
      404 ->
        []

      _ ->
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
  end

  def global_emotes() do
    Twitch.Api.emotes(["0"])
    |> Map.get("emoticon_sets")
    |> Map.values()
    |> List.flatten()
    |> Enum.map(&Twitch.Emote.from_twitch_json/1)
  end
end
