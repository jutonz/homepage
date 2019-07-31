defmodule Twitch.BttvApiMock do
  def connection(:get, "frankerfacez_emotes/channels/good-channel-id") do
    %{
      "emotes" => [
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
    }
  end

  def connection(:get, "frankerfacez_emotes/channels/bad-channel-id") do
    %{"message" => "Channel Not Found", "status" => 404}
  end
end
