defprotocol Twitch.WebhookSubscriptions.Topic do
  @doc "Turn a struct into a topic URL"
  def topic(struct)
end

defimpl Twitch.WebhookSubscriptions.Topic, for: Twitch.Channel do
  def topic(channel) do
    channel_id =
      channel.name
      |> Twitch.Channel.without_irc_prefix()
      |> Twitch.Api.user()
      |> Map.get("_id")

    "https://api.twitch.tv/helix/streams?user_id=#{channel_id}"
  end
end
