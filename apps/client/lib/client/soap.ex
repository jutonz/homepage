defmodule Client.Soap do
  import Ecto.Query, only: [from: 2]
  alias Client.Repo
  alias Client.Soap.Recipe

  def list_recipes() do
    []
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
end
