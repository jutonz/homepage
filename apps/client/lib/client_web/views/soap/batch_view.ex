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

  def amount_produced(batch) do
    case batch.amount_produced do
      nil -> "not specified"
      amount -> "#{amount}g"
    end
  end

  @spec cost_of_32oz(Client.Soap.Batch.t()) :: String.t()
  def cost_of_32oz(%{amount_produced: nil}),
    do: "n/a"

  @grams_per_floz "29.5735296875"
  def cost_of_32oz(%{amount_produced: amount_produced_in_grams} = batch) do
    {grams_per_floz, _rem} = Decimal.parse(@grams_per_floz)
    amount_produced_in_floz = Decimal.div(amount_produced_in_grams, grams_per_floz)

    total_cost = batch |> cost_of_ingredients() |> Money.to_decimal()
    cost_per_floz = Decimal.div(total_cost, amount_produced_in_floz)

    cost_per_floz
    |> Decimal.mult(32)
    |> Decimal.mult(100)
    |> Decimal.round()
    |> Decimal.to_integer()
    |> Money.new()
  end
end
