defmodule Client.Soap do
  import Ecto.Query, only: [from: 2]
  alias Client.Repo
  alias Client.Soap.{
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

  ##############################################################################
  # Create
  ##############################################################################

  def create_batch(attrs),
    do: attrs |> new_batch_changeset() |> Repo.insert()

  def create_order(attrs),
    do: attrs |> new_order_changeset() |> Repo.insert()

  def create_ingredient(attrs),
    do: attrs |> new_ingredient_changeset() |> Repo.insert()

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

  def get_batch_with_ingredients(user_id, id),
    do: user_id |> get_batch(id) |> Repo.preload(:ingredients)

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

  ##############################################################################
  # Delete
  ##############################################################################

  def delete_batch(user_id, id),
    do: user_id |> get_batch(id) |> Repo.delete()

  def delete_order(user_id, id),
    do: user_id |> get_order(id) |> Repo.delete()
end
