defmodule Twitch.Eventsub.Subscriptions.Callback do
  alias Twitch.Eventsub.ChannelUpdates

  def perform(%{type: "channel.update"}, %{"event" => event}) do
    event
    |> extract_attrs()
    |> Map.put(:type, "channel.update")
    |> ChannelUpdates.create()
  end

  def perform(%{type: "stream.online"}, %{"event" => event}) do
    case event["type"] do
      "live" ->
        event
        |> extract_attrs()
        |> Map.put(:type, "stream.online")
        |> ChannelUpdates.create()

      _ ->
        nil
    end
  end

  def perform(%{type: "stream.offline"}, %{"event" => event}) do
    case event["type"] do
      "live" ->
        event
        |> extract_attrs()
        |> Map.put(:type, "stream.offline")
        |> ChannelUpdates.create()

      _ ->
        nil
    end
  end

  def perform(_sub, _body) do
    {:ok, nil}
  end

  defp extract_attrs(event) do
    %{
      twitch_user_id: event["broadcaster_user_id"],
      title: event["title"],
      category_id: event["category_id"],
      category_name: event["category_name"]
    }
  end
end
