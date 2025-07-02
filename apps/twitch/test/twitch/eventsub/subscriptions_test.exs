defmodule Twitch.Eventsub.SubscriptionsTest do
  use Twitch.DataCase, async: true
  import Mox
  alias Twitch.Eventsub.Subscriptions

  setup :reset_api_token_cache

  describe ".create/1" do
    test "creates a new subscription" do
      stub_auth_request()

      opts = %{
        type: "stream.online",
        condition: %{"broadcaster_user_id" => "123"},
        version: 1
      }

      stub_successful_subscription_create_request(opts)

      {:ok, %{subscription: subscription}} = Subscriptions.create(opts)

      assert subscription.id
      assert subscription.type == opts[:type]
      assert subscription.condition == opts[:condition]
      assert subscription.version == opts[:version]
      assert Subscriptions.get_by_config(opts)
    end

    test "does not insert a subscription record if the api request fails" do
      stub_auth_request()

      opts = %{
        type: "stream.online",
        condition: %{"broadcaster_user_id" => "123"},
        version: 1
      }

      stub_failed_subscription_create_request()

      {:error, _response} = Subscriptions.create(opts)

      refute Subscriptions.get_by_config(opts)
    end
  end

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

  defp stub_successful_subscription_create_request(opts) do
    Twitch.HttpMock
    |> expect(:request, fn
      %{url: "https://api.twitch.tv/helix/eventsub/subscriptions"} ->
        body = %{
          "data" => [
            %{
              "condition" => opts[:condition],
              "cost" => 0,
              "created_at" => "2021-11-28T15:47:06.06282621Z",
              "id" => "19f7ec2e-b969-4213-bcee-564ec16a3473",
              "status" => "webhook_callback_verification_pending",
              "transport" => %{
                "callback" => "https://dank.loca.lt/api/twitch/subscriptions/9",
                "method" => "webhook"
              },
              "type" => opts[:type],
              "version" => to_string(opts[:version])
            }
          ],
          "max_total_cost" => 10000,
          "total" => 1,
          "total_cost" => 0
        }

        response = %{body: JSON.encode!(body), status_code: 200}
        {:ok, response}
    end)
  end

  defp stub_failed_subscription_create_request do
    Twitch.HttpMock
    |> expect(:request, fn
      %{url: "https://api.twitch.tv/helix/eventsub/subscriptions"} ->
        body = %{
          "error" => "Bad Request",
          "message" =>
            "callback must provide valid https callback with standard port in creation request",
          "status" => 400
        }

        response = %{body: JSON.encode!(body), status_code: 400}
        {:error, response}
    end)
  end
end
