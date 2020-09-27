defmodule ClientWeb.WaterFilterView do
  use ClientWeb, :view
  alias Timex.Format.DateTime.Formatters.Strftime
  alias Timex.Timezone

  def formatted_lifespan(_lifespan = nil), do: "-"
  def formatted_lifespan(lifespan), do: "#{lifespan} L"

  @format "%d %b %Y %H:%M"
  def formatted_date(date),
    do: date |> Timezone.convert(timezone()) |> Strftime.format!(@format)

  defp timezone,
    do: Application.get_env(:client, :default_timezone)
end
