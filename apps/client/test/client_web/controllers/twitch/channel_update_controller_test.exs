defmodule ClientWeb.Twitch.ChannelUpdateControllerTest do
  use ClientWeb.ConnCase, async: true
  import Mox
  import Twitch.ApiTestHelpers

  setup :reset_api_token_cache

  describe "index" do
    test "it shows updates for the given user", %{conn: conn} do
      stub_auth_request()
      stub_twitch_user_call("me", "123")

      update =
        Twitch.Factory.insert(:twitch_channel_update,
          twitch_user_id: "123"
        )

      doc =
        conn
        |> get(Routes.twitch_channel_channel_update_path(conn, :index, "me"))
        |> parsed_html_response(200)

      [update_row] = Floki.find(doc, "[data-update-id=#{update.id}]")
      text = Floki.text(update_row)
      assert text =~ update.title
      assert text =~ update.category_name
    end

    test "doesn't show updates for other users", %{conn: conn} do
      stub_auth_request()
      stub_twitch_user_call("me", "123")

      update =
        Twitch.Factory.insert(:twitch_channel_update,
          twitch_user_id: "someone_else"
        )

      doc =
        conn
        |> get(Routes.twitch_channel_channel_update_path(conn, :index, "me"))
        |> parsed_html_response(200)

      assert [] = Floki.find(doc, "[data-update-id=#{update.id}]")
    end

    test "renders an error if the twitch user can't be found", %{conn: conn} do
      stub_auth_request()
      stub_failed_twitch_user_call()

      text =
        conn
        |> get(Routes.twitch_channel_channel_update_path(conn, :index, "me"))
        |> parsed_html_response(200)
        |> Floki.text()

      assert text =~ "Sorry, I couldn't find that twitch user"
    end
  end

  defp stub_twitch_user_call(login, id) do
    Twitch.HttpMock
    |> expect(:request, 1, fn %{url: "https://api.twitch.tv/helix/users"} ->
      body = %{
        "data" => [
          %{
            "broadcaster_type" => "partner",
            "created_at" => "2011-12-20T12:13:21Z",
            "description" => "Never late, always deathless.",
            "display_name" => login,
            "id" => id,
            "login" => login,
            "offline_image_url" =>
              "https://static-cdn.jtvnw.net/jtv_user_pictures/60c276089f765482-channel_offline_image-1920x1080.png",
            "profile_image_url" =>
              "https://static-cdn.jtvnw.net/jtv_user_pictures/elajjaz-profile_image-fcfc55e0804b6bfd-300x300.png",
            "type" => "",
            "view_count" => 64_853_101
          }
        ]
      }

      response = %{body: JSON.encode!(body), status_code: 200}
      {:ok, response}
    end)
  end

  defp stub_failed_twitch_user_call do
    Twitch.HttpMock
    |> expect(:request, 1, fn %{url: "https://api.twitch.tv/helix/users"} ->
      body = %{"data" => []}
      # it does actually return status 200
      response = %{body: JSON.encode!(body), status_code: 200}
      {:ok, response}
    end)
  end
end
