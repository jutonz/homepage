defmodule ClientWeb.Twitch.Subscriptions.CallbackControllerTest do
  use ClientWeb.ConnCase, async: true
  alias Twitch.Eventsub.Subscriptions

  describe "callback" do
    test "handles stream.online event", %{conn: conn} do
      broadcaster_user_id = Ecto.UUID.generate()

      sub =
        Twitch.Factory.insert(:twitch_eventsub_subscription,
          type: "stream.online"
        )

      path =
        Routes.twitch_subscriptions_callback_path(
          conn,
          :callback,
          sub
        )

      params = %{
        "event" => %{
          "broadcaster_user_id" => broadcaster_user_id,
          "broadcaster_user_login" => "syps_",
          "broadcaster_user_name" => "syps_",
          "id" => "43917961564",
          "started_at" => "2021-11-27T15:51:08Z",
          "type" => "live"
        },
        "subscription" => %{
          "condition" => %{"broadcaster_user_id" => "86120737"},
          "cost" => 0,
          "created_at" => "2021-11-27T15:44:57.144311465Z",
          "id" => "57d31191-0ea7-4c18-b7e1-4d3325cdce2b",
          "status" => "enabled",
          "transport" => %{
            "callback" => "https://dank.loca.lt/api/twitch/subscriptions/7",
            "method" => "webhook"
          },
          "type" => "stream.online",
          "version" => "1"
        }
      }

      conn =
        conn
        |> verify_request()
        |> put_message_type("notification")
        |> post(path, params)

      assert conn.status == 204

      update =
        Twitch.Eventsub.ChannelUpdates.Update
        |> Twitch.Repo.get_by(twitch_user_id: broadcaster_user_id)

      assert update
      assert update.type == "stream.online"
      refute update.title
      refute update.category_id
      refute update.category_name
    end

    test "handles stream.offline event", %{conn: conn} do
      broadcaster_user_id = Ecto.UUID.generate()

      sub =
        Twitch.Factory.insert(:twitch_eventsub_subscription,
          type: "stream.offline"
        )

      path =
        Routes.twitch_subscriptions_callback_path(
          conn,
          :callback,
          sub
        )

      params = %{
        "event" => %{
          "broadcaster_user_id" => broadcaster_user_id,
          "broadcaster_user_login" => "syps_",
          "broadcaster_user_name" => "syps_"
        },
        "subscription" => %{
          "condition" => %{"broadcaster_user_id" => "86120737"},
          "cost" => 0,
          "created_at" => "2021-11-27T18:02:01.843507334Z",
          "id" => "e5d6d9cb-882d-46a4-a13e-d22ee9a3e7e8",
          "status" => "enabled",
          "transport" => %{
            "callback" => "https://dank.loca.lt/api/twitch/subscriptions/10",
            "method" => "webhook"
          },
          "type" => "stream.offline",
          "version" => "1"
        }
      }

      conn =
        conn
        |> verify_request()
        |> put_message_type("notification")
        |> post(path, params)

      assert conn.status == 204

      update =
        Twitch.Eventsub.ChannelUpdates.Update
        |> Twitch.Repo.get_by(twitch_user_id: broadcaster_user_id)

      assert update
      assert update.type == "stream.offline"
      refute update.title
      refute update.category_id
      refute update.category_name
    end
  end

  defp verify_request(conn) do
    conn
    |> put_req_header("twitch-eventsub-message-id", "a")
    |> put_req_header("twitch-eventsub-message-timestamp", "b")
    |> put_req_header("twitch-eventsub-message-signature", signature("abc"))
    |> assign(:raw_body, ["c"])
  end

  defp put_message_type(conn, type) do
    conn
    |> put_req_header("twitch-eventsub-message-type", type)
  end

  defp signature(message) do
    Subscriptions.calculate_signature(message)
  end
end
