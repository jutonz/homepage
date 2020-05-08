defmodule Client.Soap.BatchIngredient do
  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset

  alias Client.{
    Repo,
    Soap,
    Soap.Batch,
    Soap.Ingredient,
    Soap.Order
  }

  @schema %{
    batch_id: :integer,
    ingredient_id: :integer,
    user_id: :integer,
    amount_used: :integer
  }

  @spec changeset(map(), map()) :: Ecto.Changeset.t()
  def changeset(batch_ingredient, attrs \\ %{}) do
    {batch_ingredient, @schema}
    |> cast(attrs, ~w[batch_id ingredient_id user_id amount_used]a)
    |> validate_required(~w[batch_id ingredient_id user_id amount_used]a)
  end

  def insert(%Ecto.Changeset{valid?: false} = changeset) do
    changeset = Map.put(changeset, :action, :insert)
    {:error, changeset}
  end

  def insert(changeset) do
    case create(
           get_field(changeset, :user_id),
           get_field(changeset, :ingredient_id),
           get_field(changeset, :batch_id)
         ) do
      {:ok, ingredient} ->
        {:ok, ingredient}

      {:error, message} ->
        changeset =
          changeset
          |> add_error(:ingredient_id, message)
          |> Map.put(:action, :insert)

        {:error, changeset}
    end
  end

  @spec create(number(), number(), number()) :: {:ok, Ingredient.t()} | {:error, String.t()}
  defp create(user_id, ingredient_id, batch_id) do
    with {:ok, batch} <- get_batch_with_ingredients(user_id, batch_id),
         {:ok, ingredient} <- get_ingredient(user_id, ingredient_id),
         {:ok, ingredient} <- add_ingredient_to_batch(ingredient, batch) do
      {:ok, ingredient}
    end
  end

  @spec get_batch_with_ingredients(number(), number()) :: {:ok, Batch.t()} | {:error, String.t()}
  defp get_batch_with_ingredients(user_id, batch_id) do
    case Soap.get_batch_with_ingredients(user_id, batch_id) do
      nil -> {:error, "No such batch"}
      batch -> {:ok, batch}
    end
  end

  @spec get_ingredient(number(), number()) :: {:ok, Ingredient.t()} | {:error, String.t()}
  defp get_ingredient(user_id, ingredient_id) do
    query =
      from(
        i in Ingredient,
        join: o in Order,
        on: o.id == i.order_id,
        where: o.user_id == ^user_id,
        where: i.id == ^ingredient_id
      )

    case Repo.one(query) do
      nil -> {:error, "No such ingredient"}
      ingredient -> {:ok, ingredient}
    end
  end

  @spec add_ingredient_to_batch(Ingredient.t(), Batch.t()) ::
          {:ok, Batch.t()} | {:error, Ecto.Changeset.t()}
  defp add_ingredient_to_batch(ingredient, batch_with_ingredients) do
    batch_with_ingredients
    |> Batch.changeset_add_ingredient(ingredient)
    |> Repo.update()
    |> case do
      {:ok, _batch} -> {:ok, ingredient}
      {:error, changeset} -> {:error, Client.Util.errors_to_sentence(changeset)}
    end
  end
end
