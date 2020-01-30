defmodule ClientWeb.WaterLogView do
  use ClientWeb, :view
  alias Timex.Format.DateTime.Formatters.Strftime
  alias Timex.Timezone

  @format "%d %b %Y %H:%M"
  def formatted_date(date),
    do: date |> Timezone.convert(timezone()) |> Strftime.format!(@format)

  defp timezone,
    do: Application.get_env(:client, :default_timezone)
end
