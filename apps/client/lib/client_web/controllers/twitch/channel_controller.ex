defmodule ClientWeb.Twitch.ChannelController do
  use ClientWeb, :controller

  def show(conn, %{"name" => name} = _params) do
    case channel_stream(name) do
      nil -> render(conn, "show_notlive.html", name: name)
      stream -> render(conn, "show_live.html", name: name, stream: stream)
    end
  end

  defp channel_stream(channel_name) do
    with %{"_id" => channel_id} <- Twitch.Api.channel(channel_name),
         stream <- Twitch.Api.streams(channel_id),
         stream when is_map(stream) <- Map.get(stream, "stream") do
      stream
    else
      _ -> nil
    end
  end
end
