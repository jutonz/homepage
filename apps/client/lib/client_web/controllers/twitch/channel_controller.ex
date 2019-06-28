defmodule ClientWeb.Twitch.ChannelController do
  use ClientWeb, :controller

  def show(conn, %{"name" => name} = _params) do
    stream = channel_stream(name)
    conn |> render("show.html", name: name, stream: stream)
  end

  defp channel_stream(channel_name) do
    with %{"_id" => channel_id} <- Twitch.Api.channel(channel_name) do
      Twitch.Api.streams(channel_id)
    else
      _ -> %{}
    end
  end
end
