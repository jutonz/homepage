defmodule ClientWeb.Twitch.Subscriptions.CallbackControllerTest do
  use ClientWeb.ConnCase, async: true

  describe "POST /api/twitch/subscriptions/:id" do
    test "creates a callback event with the provided data", %{conn: conn} do
      sub = insert(:webhook_subscription)
      params = %{
        "data" => [
          %{
            "game_id" => "123",
            "user_id" => "456"
          }
        ]
      }

      require IEx; IEx.pry()

      conn
      #|> post(twitch_subscriptions_callback_path(conn, :callback), params)
      #|> json_response()
      #|> IO.inspect()
    end
  end
end
