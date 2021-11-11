defmodule ClientWeb.Twitch.ChannelView do
  use ClientWeb, :view

  @one_minute_seconds 60
  @one_hour_seconds @one_minute_seconds * 60

  def formatted_uptime(stream) do
    {:ok, live_at, _offset} = DateTime.from_iso8601(stream["started_at"])
    now = DateTime.utc_now()
    live_for_seconds = DateTime.diff(now, live_at)

    format_seconds(live_for_seconds)
  end

  def format_seconds(seconds), do: format_seconds(seconds, 0, 0)

  defp format_seconds(seconds, minutes, hours) do
    cond do
      seconds < @one_minute_seconds ->
        "#{hours} hours, #{minutes} minutes, and #{seconds} seconds"

      seconds >= @one_hour_seconds ->
        format_seconds(seconds - @one_hour_seconds, minutes, hours + 1)

      seconds >= @one_minute_seconds ->
        format_seconds(seconds - @one_minute_seconds, minutes + 1, hours)
    end
  end
end
