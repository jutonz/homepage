defmodule Client.Soap.Batch do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          name: String.t() | nil
        }

  schema "soap_batches" do
    belongs_to(:user, Client.User)
    has_many(:batch_ingredients, Client.Soap.BatchIngredient)
    field(:name, :string)
    field(:amount_produced, :integer)
    timestamps()
  end

  def changeset(batch, attrs \\ %{}) do
    batch
    |> cast(attrs, optional_fields() ++ required_fields())
    |> validate_required(required_fields())
  end

  def changeset_add_ingredient(batch_with_ingredients, new_ingredient) do
    ingredients = [new_ingredient | batch_with_ingredients.ingredients]

    batch_with_ingredients
    |> change()
    |> put_assoc(:ingredients, ingredients)
  end

  defp optional_fields,
    do: ~w[amount_produced]a

  defp required_fields,
    do: ~w[name user_id]a
end
