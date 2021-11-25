defmodule Twitch.Eventsub.SubscriptionsTest do
  use Twitch.DataCase, async: true
  alias Twitch.Eventsub.Subscriptions

  describe ".get_by_config/1" do
    test "returns a subscription matching all config options" do
      config = %{
        type: "channel.update",
        version: 1,
        condition: %{"broadcaster_user_id" => "123"}
      }

      _exact_match = insert(:twitch_eventsub_subscription, config)

      _partial_match =
        insert(:twitch_eventsub_subscription, %{
          type: config[:type],
          version: config[:version],
          condition: %{"broadcaster_user_id" => "456"}
        })

      result = Subscriptions.get_by_config(config)

      assert result
      assert result.type == config[:type]
      assert result.version == config[:version]
      assert result.condition == config[:condition]
    end
  end
end
