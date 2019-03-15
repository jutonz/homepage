defmodule ClientWeb.TwitchEmoteChannel do
  use Phoenix.Channel

  def join("twitch_emote:" <> channel_name, _message, socket) do
    IO.puts("joining channel twitch_emote:#{channel_name}")
    {:ok, socket}
  end
end
