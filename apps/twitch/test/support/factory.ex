defmodule Twitch.Factory do
  use ExMachina.Ecto, repo: Twitch.Repo

  def user_factory do
    %Twitch.User{
      email: "jutonz42@gmail.com",
      display_name: "syps_",
      user_id: sequence("id"),
      twitch_user_id: sequence("twitch_user_id")
    }
  end

  def channel_factory do
    %Twitch.Channel{
      name: "#comradenerdy",
      user: build(:user)
    }
  end

  def emote_factory do
    %Twitch.Bttv.Emote{
      channel: "cfusion",
      code: "nepSmug",
      id: "55da21e58b9916ef4b249f10",
      image_type: "png",
      regex: ~r/nepSmug/
    }
  end

  def event_factory do
    %Twitch.TwitchEvent{
      channel: "#comradenerdy",
      display_name: "syps_",
      message: "TaBeRu",
      raw_event: ":syps_!syps_@syps_.tmi.twitch.tv PRIVMSG #comradenerdy :TaBeRu"
    }
  end

  def parsed_event_factory do
    %Twitch.ParsedEvent{
      id: sequence("id"),
      channel: "#comradenerdy",
      display_name: "syps_",
      message: "TaBeRu",
      raw_event: ":syps_!syps_@syps_.tmi.twitch.tv PRIVMSG #comradenerdy :Kappa TaBeRu",
      tags: %{
        "emotes" => "25:0-4"
      }
    }
  end

  def gambling_event_factory do
    event =
      build(:event, %{
        channel: "#comradenerdy",
        message: "syps_ won 566 blyats in roulette and now has 61132 blyats! FeelsGoodMan",
        display_name: "syps_",
        raw_event:
          ":takeitbot!takeitbot@takeitbot.tmi.twitch.tv PRIVMSG #comradenerdy :takeitbot won 566 blyats in roulette and now has 61132 blyats! FeelsGoodMan"
      })

    %Twitch.GamblingEvent{
      channel: "#comradenerdy",
      gamble_type: "routlette",
      won: true,
      twitch_event: event
    }
  end

  def webhook_subscription_factory do
    %Twitch.WebhookSubscriptions.Subscription{
      user_id: insert(:user).id,
      topic: "https://api.twitch.tv/helix/streams?user_id=26921830",
      secret: "abc123",
      expires_at: DateTime.add(DateTime.utc_now(), 10_000, :second),
      confirmed: true
    }
  end

  def webhook_subscription_callback_factory do
    body = %{
      "data" => [
        %{
          "game_id" => "15825",
          "id" => "114544609",
          "language" => "en",
          "started_at" => "2019-10-31T14:55:14Z",
          "tag_ids" => ["6ea6bca4-4712-4ab9-a906-e3336a9d8039"],
          "thumbnail_url" =>
            "https://static-cdn.jtvnw.net/previews-ttv/live_user_elajjaz-{width}x{height}.jpg",
          "title" => "W.o.r.m.s against chat 👻    @Elajjaz Twitter/Instagram",
          "type" => "live",
          "user_id" => "26921830",
          "user_name" => "Elajjaz",
          "viewer_count" => 4560
        }
      ]
    }

    %Twitch.WebhookSubscriptions.Callbacks.Callback{
      subscription_id: insert(:webhook_subscription).id,
      user_id: get_in(body, ~w[data user_id]),
      game_id: get_in(body, ~w[data game_id]),
      body: body
    }
  end
end
