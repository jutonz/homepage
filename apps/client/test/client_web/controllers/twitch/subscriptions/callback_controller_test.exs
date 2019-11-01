defmodule ClientWeb.Twitch.Subscriptions.CallbackControllerTest do
  use ClientWeb.ConnCase, async: true

  describe "POST /api/twitch/subscriptions/:id" do
    test "creates a callback event with the provided data", %{conn: conn} do
      sub = Twitch.Factory.insert(:webhook_subscription)
      params = %{
        "data" => [
          %{
            "game_id" => "123",
            "user_id" => "456"
          }
        ]
      }

      conn
      |> Plug.Conn.put_req_header("x-hub-signature", "123")
      |> Plug.Conn.put_req_header("content-type", "application/json")
      |> post(twitch_subscriptions_callback_path(conn, :callback, sub.id), params)
      |> IO.inspect()
    end
  end
end
