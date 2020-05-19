defmodule Client.Soap do
  import Ecto.Query, only: [from: 2]
  alias Client.Repo

  alias Client.Soap.{
    BatchIngredient,
    Ingredient,
    Order,
    Batch
  }

  ##############################################################################
  # Index
  ##############################################################################

  def list_batches(user_id) do
    query = from(r in Batch, where: r.user_id == ^user_id)
    Repo.all(query)
  end

  def list_orders(user_id) do
    query = from(r in Order, where: r.user_id == ^user_id)
    Repo.all(query)
  end

  ##############################################################################
  # Changesets
  ##############################################################################

  def new_batch_changeset(attrs \\ %{}),
    do: Batch.changeset(%Batch{}, attrs)

  def batch_changeset(batch, attrs \\ %{}),
    do: Batch.changeset(batch, attrs)

  def new_order_changeset(attrs \\ %{}),
    do: Order.changeset(%Order{}, attrs)

  def order_changeset(order, attrs \\ %{}),
    do: Order.changeset(order, attrs)

  def new_ingredient_changeset(attrs \\ %{}),
    do: Ingredient.changeset(%Ingredient{}, attrs)

  def ingredient_changeset(ingredient, attrs \\ %{}),
    do: Ingredient.changeset(ingredient, attrs)

  def new_batch_ingredient_changeset(attrs \\ %{}),
    do: BatchIngredient.changeset(%BatchIngredient{}, attrs)

  ##############################################################################
  # Create
  ##############################################################################

  def create_batch(attrs),
    do: attrs |> new_batch_changeset() |> Repo.insert()

  def create_order(attrs),
    do: attrs |> new_order_changeset() |> Repo.insert()

  def create_ingredient(attrs),
    do: attrs |> new_ingredient_changeset() |> Repo.insert()

  def create_batch_ingredient(attrs),
    do: attrs |> new_batch_ingredient_changeset() |> BatchIngredient.insert()

  ##############################################################################
  # Get
  ##############################################################################

  def get_batch(user_id, id) do
    query =
      from(r in Batch,
        where: r.user_id == ^user_id,
        where: r.id == ^id
      )

    Repo.one(query)
  end

  def get_batch_with_ingredients(user_id, id) do
    user_id
    |> get_batch(id)
    |> Map.put(
      :batch_ingredients,
      id |> String.to_integer() |> get_batch_ingredients()
    )
  end

  def get_batch_ingredients(batch_id) do
    query =
      from(
        sbi in "soap_batch_ingredients",
        where: sbi.batch_id == ^batch_id,
        join: i in Ingredient,
        on: i.id == sbi.ingredient_id,
        join: o in Order,
        on: o.id == i.order_id,
        join: oi in Ingredient,
        on: oi.order_id == o.id,
        select: %{
          name: i.name,
          amount_used: sbi.amount_used,
          batch_id: sbi.batch_id,
          ingredient: %{
            id: i.id,
            quantity: i.quantity,
            cost: i.cost
          },
          order: %{
            tax: o.tax,
            shipping_cost: o.shipping_cost,
            num_ingredients: count(oi.id)
          }
        }
      )

    query
    |> Repo.all()
    |> IO.inspect()
    |> Enum.map(fn sbi ->
      material_cost = BatchIngredient.material_cost(sbi)

      order_overhead = Money.add(sbi.order.tax, sbi.order.shipping_cost)
      overhead_cost =
        order_overhead
        |> Money.to_decimal()
        |> Decimal.div(sbi.order.num_ingredients)
        |> Decimal.mult(100)
        |> Decimal.round()
        |> Decimal.to_integer()
        |> Money.new()

      map =
        sbi
        |> Map.put(:material_cost, material_cost)
        |> Map.put(:overhead_cost, overhead_cost)
        |> Map.put(:total_cost, Money.add(material_cost, overhead_cost))
        |> Map.put(:ingredient_id, sbi.ingredient.id)
        |> Map.delete(:ingredient)
        |> Map.delete(:order)

      struct!(BatchIngredient, map)
    end)
  end

  def get_batch_ingredient(user_id, batch_id, ingredient_id) do
    query =
      from(
        sbi in "soap_batch_ingredients",
        where: sbi.batch_id == ^batch_id,
        where: sbi.ingredient_id == ^ingredient_id,
        join: b in Batch,
        on: b.user_id == ^user_id,
        where: b.id == sbi.batch_id
      )

    Repo.one(query)
  end

  def get_order(user_id, id) do
    query =
      from(r in Order,
        where: r.user_id == ^user_id,
        where: r.id == ^id
      )

    Repo.one(query)
  end

  def get_order_with_ingredients(user_id, id),
    do: user_id |> get_order(id) |> Repo.preload(:ingredients)

  def get_order_ingredient(user_id, order_id, ingredient_id) do
    query =
      from(
        i in Ingredient,
        join: o in Order,
        on: o.id == ^order_id,
        on: o.user_id == ^user_id,
        where: i.id == ^ingredient_id,
        where: i.order_id == o.id
      )

    Repo.one(query)
  end

  ##############################################################################
  # Update
  ##############################################################################

  def update_batch(batch, params),
    do: batch |> batch_changeset(params) |> Repo.update()

  def update_order(order, params),
    do: order |> order_changeset(params) |> Repo.update()

  def update_ingredient(ingredient, params),
    do: ingredient |> ingredient_changeset(params) |> Repo.update()

  #def add_ingredient_to_batch(user_id, ingredient_id, batch_id) do
    #BatchIngredient.create(user_id, ingredient_id, batch_id)
  #end

  ##############################################################################
  # Delete
  ##############################################################################

  def delete_batch(user_id, id),
    do: user_id |> get_batch(id) |> Repo.delete()

  def delete_order(user_id, id),
    do: user_id |> get_order(id) |> Repo.delete()
end
