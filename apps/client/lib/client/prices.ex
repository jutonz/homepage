defmodule Client.Prices do
  def cost_of_amount_used(batch_ingredient) do
    total_amount = batch_ingredient.ingredient.quantity
    total_cost = batch_ingredient.ingredient.cost
    amount_used = batch_ingredient.amount_used

    cost_per_gram =
      total_cost
      |> Money.to_decimal()
      |> Decimal.div(total_amount)

    cost_per_gram
    |> Decimal.mult(amount_used)
    |> Decimal.mult(100)
    |> Decimal.round()
    |> Decimal.to_integer()
    |> Money.new()
  end
end
