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

    {:ok, ev} = cset |> Twitch.Repo.insert()
  end
end
