defmodule Twitch.Api do
  alias Twitch.{
    Api,
    ApiClient,
    ApiConnection
  }

  def current_user(access_token) do
    with {:ok, json} <- ApiConnection.connection(access_token, :get, "/helix/users"),
         do:
           (
             %{"data" => [user]} = json
             {:ok, user}
           ),
         else: ({:error, reason} -> {:error, reason})
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

  def user(username) do
    username
    |> Api.Users.list_by_login()
    |> ApiClient.make_request()
  end

  def streams(login) do
    login
    |> Api.Streams.list_by_login()
    |> ApiClient.make_request()
  end

  def list_eventsub_subscriptions do
    Api.Eventsub.Subscriptions.list()
    |> ApiClient.make_request()
  end

  def create_eventsub_subscription(body) do
    body
    |> Api.Eventsub.Subscriptions.create()
    |> ApiClient.make_request()
  end

  def get_eventsub_subscription(twitch_id) do
    twitch_id
    |> Api.Eventsub.Subscriptions.get()
    |> ApiClient.make_request()
  end

  def delete_eventsub_subscription(id) do
    id
    |> Api.Eventsub.Subscriptions.delete()
    |> ApiClient.make_request()
  end

  def game(game_id) do
    :get
    |> Api.Kraken.connection("helix/games", params: [id: game_id])
    |> Map.get("data")
    |> hd()
  end

  def markers(user, video_id) do
    Api.Kraken.connection(:get, "helix/streams/markers", [
      {:params, [{"video_id", video_id}]},
      access_token: user.access_token["access_token"]
    ])
  end

  def extensions(auth_token, channel_id) do
    path = "v5/channels/#{channel_id}/extensions"

    Api.Kraken.connection(:get, path, [
      {:headers, [{"Authorization", "Bearer #{auth_token}"}]}
    ])
  end

  @spec channel_emotes(String.t(), integer) :: list(Twitch.Emote.t())
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
