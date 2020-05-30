defmodule Client.Soap.BatchIngredient do
  use Ecto.Schema
  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset

  alias Client.{
    Repo,
    Soap,
    Soap.Batch,
    Soap.BatchIngredient,
    Soap.Ingredient,
    Soap.Order
  }

  @type t :: %__MODULE__{
          amount_used: integer() | nil,
          user_id: integer() | nil
        }

  schema "soap_batch_ingredients" do
    belongs_to(:ingredient, Soap.Ingredient)
    belongs_to(:batch, Soap.Batch)
    field(:amount_used, :integer)
    field(:material_cost, Money.Ecto.Amount.Type)

    field(:user_id, :integer, virtual: true)
    field(:name, :string, virtual: true)
    field(:overhead_cost, Money.Ecto.Amount.Type, virtual: true)
    field(:total_cost, Money.Ecto.Amount.Type, virtual: true)
  end

  def changeset(batch_ingredient, attrs \\ %{}) do
    batch_ingredient
    |> cast(attrs, ~w[batch_id ingredient_id user_id amount_used material_cost]a)
    |> validate_required(~w[batch_id ingredient_id user_id amount_used]a)
  end

  def material_cost(total_amount, total_cost, amount_used) do
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

  def overhead_cost(total_overhead_cost, amount_used) do
    total_overhead_cost
    |> Money.to_decimal()
    |> Decimal.div(amount_used)
    |> Decimal.mult(100)
    |> Decimal.round()
    |> Decimal.to_integer()
    |> Money.new()
  end

  def insert(%Ecto.Changeset{valid?: false} = changeset) do
    changeset = Map.put(changeset, :action, :insert)
    {:error, changeset}
  end

  def insert(changeset) do
    attrs = %{
      amount_used: get_field(changeset, :amount_used)
    }

    case create(
           get_field(changeset, :user_id),
           get_field(changeset, :ingredient_id),
           get_field(changeset, :batch_id),
           attrs
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

  @spec create(number(), number(), number(), map()) ::
          {:ok, Ingredient.t()} | {:error, String.t()}
  def create(user_id, ingredient_id, batch_id, attrs) do
    with {:ok, batch} <- get_batch_with_ingredients(user_id, batch_id),
         {:ok, ingredient} <- get_ingredient(user_id, ingredient_id),
         {:ok, ingredient} <- add_ingredient_to_batch(ingredient, batch, attrs) do
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

  @spec add_ingredient_to_batch(Ingredient.t(), Batch.t(), map()) ::
          {:ok, Ingredient.t()} | {:error, String.t()}
  defp add_ingredient_to_batch(ingredient, batch_with_ingredients, attrs) do
    %BatchIngredient{}
    |> cast(attrs, ~w[amount_used]a)
    |> put_assoc(:batch, batch_with_ingredients)
    |> put_assoc(:ingredient, ingredient)
    |> recalculate_material_cost(ingredient)
    |> Repo.insert()
    |> case do
      {:ok, _batch_ingredient} -> {:ok, ingredient}
      {:error, changeset} -> {:error, Client.Util.errors_to_sentence(changeset)}
    end
  end

  defp recalculate_material_cost(changeset, ingredient) do
    material_cost =
      material_cost(
        ingredient.quantity,
        ingredient.material_cost,
        get_field(changeset, :amount_used)
      )

    put_change(changeset, :material_cost, material_cost)
  end
end
