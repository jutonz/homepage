defmodule ClientWeb.Twitch.ChannelUpdateView do
  use ClientWeb, :view

  def type("channel.update"), do: "Update"
  def type("stream.online"), do: "Online"
  def type("stream.offline"), do: "Offline"
  def type(type), do: type

  def format_date(datetime) do
    datetime
    |> DateTime.from_naive!("Etc/UTC")
    |> DateTime.shift_zone!(timezone())
    |> Calendar.strftime("%d %b")
  end

  def format_time(datetime) do
    datetime
    |> DateTime.from_naive!("Etc/UTC")
    |> DateTime.shift_zone!(timezone())
    |> Calendar.strftime("%I:%M %P")
  end

  defp timezone do
    Application.fetch_env!(:client, :default_timezone)
  end
end
