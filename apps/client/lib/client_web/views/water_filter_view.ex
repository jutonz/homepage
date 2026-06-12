defmodule ClientWeb.WaterFilterView do
  use ClientWeb, :view

  def formatted_lifespan(_lifespan = nil), do: "-"
  def formatted_lifespan(lifespan), do: "#{lifespan} L"

  @format "%d %b %Y %H:%M"
  def formatted_date(date),
    do: date |> DateTime.shift_zone!(timezone()) |> Calendar.strftime(@format)

  defp timezone,
    do: Application.get_env(:client, :default_timezone)
end
