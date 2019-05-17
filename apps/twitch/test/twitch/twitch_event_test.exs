defmodule Twitch.TwitchEventTest do
  use Twitch.DataCase, async: true
  alias Twitch.TwitchEvent

  test "can be inserted" do
    cset =
      %TwitchEvent{}
      |> TwitchEvent.changeset(%{
        channel: "#comradenerdy",
        message: "nrdyISee",
        display_name: "syps_",
        raw_event: "fff"
      })

    {:ok, _ev = %TwitchEvent{}} = cset |> Twitch.GoogleRepo.insert()
  end
end
