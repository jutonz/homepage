defmodule ClientWeb.Twitch.ChannelController do
  use ClientWeb, :controller

  def show(conn, %{"id" => name} = params) do
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
    with {:ok, response} <- Twitch.Api.streams(channel_name),
         %{data: %{"data" => [data]}} <- response do
      data
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
