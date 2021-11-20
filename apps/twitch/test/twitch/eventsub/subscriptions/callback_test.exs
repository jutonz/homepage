defmodule Twitch.Eventsub.Subscriptions.CallbackTest do
  use Twitch.DataCase, async: true

  alias Twitch.{
    Eventsub.Subscription,
    Eventsub.Subscriptions.Callback
  }

  describe ".perform/3" do
    test "inserts a ChannelUpdate" do
      sub = %Subscription{}
      body = %{
        "event" => %{
          "broadcaster_user_id" => "id",
          "title" => "title",
          "category_id" => "category_id",
          "category_name" => "category_name"
        }
      }

      {:ok, update} = Callback.perform(sub, body, "channel.update")

      assert update.twitch_user_id == "id"
      assert update.title == "title"
      assert update.category_id == "category_id"
      assert update.category_name == "category_name"
    end

    test "returns {:ok, nil} for an unsupported type" do
      sub = %Subscription{}
      {:ok, nil} = Callback.perform(sub, %{}, "unsupported")
    end
  end
end
