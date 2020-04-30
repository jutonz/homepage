defmodule Client.Soap do
  import Ecto.Query, only: [from: 2]
  alias Client.Repo
  alias Client.Soap.Order
  alias Client.Soap.Recipe

  def list_recipes(user_id) do
    query = from(r in Recipe, where: r.user_id == ^user_id)
    Repo.all(query)
  end

  def new_recipe_changeset(attrs \\ %{}),
    do: Recipe.changeset(%Recipe{}, attrs)

  def recipe_changeset(recipe, attrs \\ %{}),
    do: Recipe.changeset(recipe, attrs)

  def create_recipe(attrs),
    do: attrs |> new_recipe_changeset() |> Repo.insert()

  def get_recipe(user_id, id) do
    query =
      from(r in Recipe,
        where: r.user_id == ^user_id,
        where: r.id == ^id
      )

    Repo.one(query)
  end

  def update_recipe(recipe, params),
    do: recipe |> recipe_changeset(params) |> Repo.update()

  def delete_recipe(user_id, id),
    do: user_id |> get_recipe(id) |> Repo.delete()

  def list_orders(user_id) do
    query = from(r in Order, where: r.user_id == ^user_id)
    Repo.all(query)
  end

  def new_order_changeset(attrs \\ %{}),
    do: Order.changeset(%Order{}, attrs)

  def order_changeset(order, attrs \\ %{}),
    do: Order.changeset(order, attrs)

  def create_order(attrs),
    do: attrs |> new_order_changeset() |> Repo.insert()

  def get_order(user_id, id) do
    query =
      from(r in Order,
        where: r.user_id == ^user_id,
        where: r.id == ^id
      )

    Repo.one(query)
  end

  def update_order(order, params),
    do: order |> order_changeset(params) |> Repo.update()

  def delete_order(user_id, id),
    do: user_id |> get_order(id) |> Repo.delete()
end
