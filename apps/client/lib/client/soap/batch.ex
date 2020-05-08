defmodule Client.Soap.Batch do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    name: String.t() | nil
  }

  schema "soap_batches" do
    belongs_to(:user, Client.User)
    many_to_many(
      :ingredients,
      Client.Soap.Ingredient,
      join_through: "soap_batch_ingredients",
      on_replace: :delete
    )
    field(:name, :string)
    timestamps()
  end

  def changeset(batch, attrs \\ %{}) do
    batch
    |> cast(attrs, required_fields())
    |> validate_required(required_fields())
  end

  def changeset_add_ingredient(batch_with_ingredients, new_ingredient) do
    ingredients = [new_ingredient | batch_with_ingredients.ingredients]

    batch_with_ingredients
    |> change()
    |> put_assoc(:ingredients, ingredients)
  end

  defp required_fields,
    do: ~w[name user_id]a
end
