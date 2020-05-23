defmodule Client.Soap.IngredientCreator do
  alias Client.Soap
  alias Client.Soap.Order

  def create(%{"order_id" => order_id} = attrs, user_id) do
    with {:ok, order} <- get_order(user_id, order_id),
         {:ok, overheads} <- calculate_overheads(order),
         {:ok, new_ingredient_changeset, overheads} <-
           create_new_ingredient_changeset(attrs, overheads),
         ingredient_changesets <- existing_ingredient_changesets(order, overheads),
         {:ok, ingredient} <- insert_changesets(new_ingredient_changeset, ingredient_changesets) do
      {:ok, ingredient}
    end
  end

  defp get_order(user_id, order_id) do
    res =
      user_id
      |> Soap.get_order(order_id)
      |> Client.Repo.preload(:ingredients)
      |> Client.Repo.preload(ingredients: :batches)

    case res do
      nil -> {:error, "No matching order"}
      order -> {:ok, order}
    end
  end

  defp calculate_overheads(order) do
    new_ingredient_count = length(order.ingredients) + 1
    total_overhead = Order.total_overhead(order)
    overheads = Money.divide(total_overhead, new_ingredient_count)

    {:ok, overheads}
  end

  defp create_new_ingredient_changeset(attrs, overheads) do
    [overhead | overheads] = overheads

    material_cost = attrs |> Map.get("material_cost") |> String.to_integer() |> Money.new()

    new_ingredient_changeset =
      attrs
      |> Map.put("overhead_cost", overhead)
      |> Map.put("total_cost", Money.add(overhead, material_cost))
      |> Soap.new_ingredient_changeset()

    case new_ingredient_changeset do
      %Ecto.Changeset{valid?: false} = changeset -> {:error, changeset}
      changeset -> {:ok, changeset, overheads}
    end
  end

  defp existing_ingredient_changesets(order, overheads) do
    order.ingredients
    |> Enum.with_index()
    |> Enum.map(fn {ingredient, index} ->
      {ingredient, Enum.at(overheads, index)}
    end)
    |> Enum.map(fn {ingredient, overhead} ->
      ingredient = Map.put(ingredient, :order, order)
      total_cost = Money.add(ingredient.material_cost, overhead)

      Soap.ingredient_changeset(ingredient, %{
        overhead_cost: overhead,
        total_cost: total_cost
      })
    end)
  end

  defp insert_changesets(new_ingredient, existing) do
    Client.Repo.transaction(fn ->
      Enum.each(existing, &Client.Repo.update!/1)
      Client.Repo.insert(new_ingredient)
    end)
  end
end
