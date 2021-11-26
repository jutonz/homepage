defmodule Twitch.Eventsub.Subscriptions.CallbackTest do
  use Twitch.DataCase, async: true

  alias Twitch.{
    Eventsub.Subscription,
    Eventsub.Subscriptions.Callback
  }

  describe ".perform/3" do
    test "inserts a record for channel.update" do
      sub =
        insert(:twitch_eventsub_subscription, %{
          type: "channel.update"
        })

      body = %{
        "event" => %{
          "broadcaster_user_id" => "id",
          "title" => "title",
          "category_id" => "category_id",
          "category_name" => "category_name"
        }
      }

      {:ok, update} = Callback.perform(sub, body)

      assert update.twitch_user_id == "id"
      assert update.title == "title"
      assert update.category_id == "category_id"
      assert update.category_name == "category_name"
      assert update.type == "channel.update"
    end

    test "inserts a record for stream.online" do
      sub =
        insert(:twitch_eventsub_subscription, %{
          type: "stream.online"
        })

      body = %{
        "event" => %{
          "broadcaster_user_id" => "id",
          "title" => "title",
          "category_id" => "category_id",
          "category_name" => "category_name",
          "type" => "live"
        }
      }

      {:ok, update} = Callback.perform(sub, body)

      assert update.twitch_user_id == "id"
      assert update.title == "title"
      assert update.category_id == "category_id"
      assert update.category_name == "category_name"
      assert update.type == "stream.online"
    end

    test "inserts a record for stream.offline" do
      sub =
        insert(:twitch_eventsub_subscription, %{
          type: "stream.offline"
        })

      body = %{
        "event" => %{
          "broadcaster_user_id" => "id",
          "title" => "title",
          "category_id" => "category_id",
          "category_name" => "category_name",
          "type" => "live"
        }
      }

      {:ok, update} = Callback.perform(sub, body)

      assert update.twitch_user_id == "id"
      assert update.title == "title"
      assert update.category_id == "category_id"
      assert update.category_name == "category_name"
      assert update.type == "stream.offline"
    end

    test "returns {:ok, nil} for an unsupported type" do
      sub = %Subscription{type: "unsupported"}
      {:ok, nil} = Callback.perform(sub, %{})
    end
  end
end
