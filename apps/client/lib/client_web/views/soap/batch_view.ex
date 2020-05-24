defmodule ClientWeb.Soap.BatchView do
  use ClientWeb, :view
  alias Timex.Format.DateTime.Formatters.Strftime
  alias Timex.Timezone

  @format "%d %b %Y %H:%M"
  def formatted_date(date),
    do: date |> Timezone.convert(timezone()) |> Strftime.format!(@format)

  defp timezone,
    do: Application.get_env(:client, :default_timezone)

  defp cost_of_ingredients(batch) do
    Enum.reduce(batch.batch_ingredients, Money.new(0), fn bi, acc ->
      Money.add(acc, bi.total_cost)
    end)
  end
end
