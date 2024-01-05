defmodule Twitch.SevenTvMock do
  def connection(:get, "/v3/users/twitch/good-channel-id") do
    %{
      "id" => "26921830",
      "platform" => "TWITCH",
      "username" => "elajjaz",
      "display_name" => "Elajjaz",
      "linked_at" => 1_637_321_817_000,
      "emote_capacity" => 1000,
      "emote_set_id" => nil,
      "emote_set" => %{
        "id" => "61978c596467596b1d6281cd",
        "name" => "Elajjaz's Emotes",
        "emotes" => [
          %{
            "id" => "603caa69faf3a00014dff0b1",
            "name" => "Okayeg"
          },
          %{
            "id" => "603caa69faf3a00014dff0b2",
            "name" => "FeelsRainMan"
          }
        ]
      }
    }
  end

  def connection(:get, "/v3/users/twitch/bad-channel-id") do
    %{
      "status_code" => "404",
      "status" => "Not Found",
      "error" => "Unknown User",
      "error_code" => "70442"
    }
  end
end
