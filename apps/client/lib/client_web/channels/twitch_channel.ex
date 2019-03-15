defmodule ClientWeb.TwitchChannel do
  use Phoenix.Channel

  def join("twitch_channel:" <> twitch_channel, _msg, socket) do
    IO.puts("joining channel twitch_channel:#{twitch_channel}")
    {:ok, socket}
  end
end
