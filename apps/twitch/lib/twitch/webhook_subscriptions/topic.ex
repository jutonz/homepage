defprotocol Twitch.WebhookSubscriptions.Topic do
  @doc "Turn a struct into a topic URL"
  def topic(struct)
end

defimpl Twitch.WebhookSubscriptions.Topic, for: Twitch.Channel do
  def topic(channel) do
    channel_name = Twitch.Channel.without_irc_prefix(channel.name)
    {:ok, response} = Twitch.Api.user(channel_name)
    %{data: %{"data" => [%{"id" => channel_id}]}} = response

    "https://api.twitch.tv/helix/streams?user_id=#{channel_id}"
  end
end
