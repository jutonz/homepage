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
    params = emote_set_ids |> Enum.map(fn(id) -> {"emotesets[]", id} end)
    Api.Kraken.connection(:get, path, params: params)
  end

  def channel(channel_name) do
    path = "kraken/channels/#{channel_name}"
    Api.Kraken.connection(:get, path, [
      {:headers, [{"Accept", "application/vnd.twitchtv.v3+json"}]}
    ])
  end

  def channel_emotes(channel_name) do
    product_data = Twitch.Api.Kraken.connection(:get, "channels/#{channel_name}/product")
    t3_plan = product_data["plans"] |> Enum.find(fn(plan) -> plan["plan"] == "3000" end)
    t3_emote_sets = t3_plan["emoticon_set_ids"]

    IO.inspect t3_emote_sets

    f = t3_emote_sets
    |> Api.emotes()
    #|> Map.get("emoticon_sets")

    IO.inspect f

    f |> Enum.reduce([], fn({_emoticon_set_id, emotes}, result) ->
      result ++ emotes
    end)


    #IO.inspect t3_emote_sets

    #emote_sets = Api.emotes(t3_emote_sets)

    #res |> Map.get("emoticon_sets") |> Enum.reduce([], fn({_set_id, emotes}, result) -> result ++ emotes end)
  end
end
