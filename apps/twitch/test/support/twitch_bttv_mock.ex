defmodule Twitch.BttvApiMock do
  def connection(:get, "cached/frankerfacez/users/twitch/good-channel-id") do
    [
      %{
        "channel" => %{"name" => "brandinio_"},
        "code" => "FeelsBlyatMan",
        "id" => 298_514,
        "imageType" => "png",
        "images" => %{
          "1x" => "https://cdn.betterttv.net/frankerfacez_emote/298514/1",
          "2x" => "https://cdn.betterttv.net/frankerfacez_emote/298514/2",
          "4x" => "https://cdn.betterttv.net/frankerfacez_emote/298514/4"
        }
      }
    ]
  end

  def connection(:get, "cached/frankerfacez/users/twitch/bad-channel-id") do
    []
  end
end
