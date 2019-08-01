defmodule Twitch.TwitchEmotesApiMock do
  @kappa %{
    "channel_id" => nil,
    "channel_name" => nil,
    "code" => "Kappa",
    "emoticon_set" => 0,
    "id" => 25
  }

  def connection(:get, "/api/v4/emotes", params: [{"id", "25"}]), do: [@kappa]
  def connection(:get, "/api/v4/emotes", params: [{"id", "bad-id"}]), do: []
end
