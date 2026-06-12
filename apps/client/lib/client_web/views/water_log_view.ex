defmodule ClientWeb.WaterLogView do
  use ClientWeb, :view

  @format "%d %b %Y %H:%M"
  def formatted_date(%NaiveDateTime{} = date),
    do: date |> DateTime.from_naive!("Etc/UTC") |> formatted_date()

  def formatted_date(%DateTime{} = date),
    do: date |> DateTime.shift_zone!(timezone()) |> Calendar.strftime(@format)

  defp timezone,
    do: Application.get_env(:client, :default_timezone)
end
