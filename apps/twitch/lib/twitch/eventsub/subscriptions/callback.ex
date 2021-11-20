defmodule Twitch.Eventsub.Subscriptions.Callback do
  alias Twitch.Eventsub.ChannelUpdate

  def perform(_sub, %{"event" => event}, "channel.update") do
    attrs = %{
      twitch_user_id: event["broadcaster_user_id"],
      title: event["title"],
      category_id: event["category_id"],
      category_name: event["category_name"]
    }

    %ChannelUpdate{}
    |> ChannelUpdate.changeset(attrs)
    |> Twitch.Repo.insert()
  end

  def perform(_sub, _body, _type) do
    {:ok, nil}
  end
end
