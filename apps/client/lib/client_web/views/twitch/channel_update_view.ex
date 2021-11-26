defmodule ClientWeb.Twitch.ChannelUpdateView do
  use ClientWeb, :view

  def type("channel.update"), do: "Update"
  def type("stream.online"), do: "Online"
  def type("stream.offline"), do: "Offline"
  def type(type), do: type
end
