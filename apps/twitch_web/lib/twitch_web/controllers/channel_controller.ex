defmodule TwitchWeb.ChannelController do
  use TwitchWeb, :controller

  def show(conn, %{"name" => name} = params) do
    stream = channel_stream(name)
    {:ok, _pid} = subscribe_to_chat(name)

    case stream do
      nil ->
        render(conn, "show_notlive.html", name: name)

      stream ->
        others = filter_others(params["and"])
        render(conn, "show_live.html", name: name, stream: stream, others: others)
    end
  end

  defp filter_others(nil = _other_channel_names), do: []
  defp filter_others(other_channel_names), do: Enum.uniq(other_channel_names)

  defp channel_stream(channel_name) do
    with %{"_id" => user_id} <- Twitch.Api.user(channel_name),
         stream <- Twitch.Api.streams(user_id),
         stream when is_map(stream) <- Map.get(stream, "stream") do
      stream
    else
      _ -> nil
    end
  end

  defp subscribe_to_chat(channel_name) do
    channel_name
    |> Twitch.Channel.with_irc_prefix()
    |> Twitch.ChannelSubscriptionSupervisor.subscribe_to_chat()
  end
end
