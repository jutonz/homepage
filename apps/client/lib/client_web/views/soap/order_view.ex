defmodule ClientWeb.Soap.OrderView do
  use ClientWeb, :view

  def cost_of_ingredients(order) do
    Enum.reduce(order.ingredients, Money.new(0), fn ing, cost ->
      Money.add(cost, ing.cost)
    end)
  end

  def total_cost(order) do
    order.shipping_cost
    |> Money.add(cost_of_ingredients(order))
    |> Money.add(order.tax)
  end
end
