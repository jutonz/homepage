defmodule Twitch.WebhookSubscriptions.CallbacksTest do
  use Twitch.DataCase, async: true
  alias Twitch.WebhookSubscriptions.Callbacks

  describe "create/2" do
    test "creates a callback when data is passed as expected" do
      sub = insert(:webhook_subscription)

      body = %{
        "data" => [
          %{
            "game_id" => "15825",
            "user_id" => "26921830"
          }
        ]
      }

      {:ok, callback} = Callbacks.create(sub.id, body)
      assert callback.subscription_id == sub.id
      assert callback.game_id == "15825"
      assert callback.user_id == "26921830"
      assert callback.body == body
    end
  end
end
