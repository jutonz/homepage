defmodule ClientWeb.Soap.OrderView do
  use ClientWeb, :view

  def material_cost_of_ingredients(order) do
    Enum.reduce(order.ingredients, Money.new(0), fn ing, cost ->
      Money.add(cost, ing.material_cost)
    end)
  end

  def total_cost(order) do
    order
    |> material_cost_of_ingredients()
    |> Money.add(Client.Soap.Order.total_overhead(order))
  end
end
