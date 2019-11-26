defmodule Twitch.WebhookSubscriptions.SigningTest do
  use Twitch.DataCase, async: true
  # alias Twitch.WebhookSubscriptions.Signing

  # test "calculates the correct signature" do
  # actual = """
  # {"data":[{"viewer_count":0,"user_name":"syps_","user_id":"86120737","type":"live","title":"woah","thumbnail_url":"https://static-cdn.jtvnw.net/previews-ttv/live_user_syps_-{width}x{height}.jpg","tag_ids":["6ea6bca4-4712-4ab9-a906-e3336a9d8039"],"started_at":"2019-10-29T00:08:03Z","language":"en","id":"36092863040","game_id":"509658"}]}
  # """
  # |> Jason.encode!()
  # |> Signing.signature()

  # expected = "sha256=c6e5c9c963a3582a95fb6e1ca8c27154076ffb226d5efc91d9d4843de3caeeb2"

  # assert actual == expected
  # end
end
