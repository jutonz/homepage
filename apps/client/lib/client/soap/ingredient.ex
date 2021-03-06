defmodule Client.Soap.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          name: String.t() | nil,
          depleted_at: DateTime.t()
        }

  schema "soap_ingredients" do
    belongs_to(:order, Client.Soap.Order)
    has_many(:batch_ingredients, Client.Soap.BatchIngredient)

    many_to_many(
      :batches,
      Client.Soap.Batch,
      join_through: "soap_batch_ingredients",
      on_replace: :delete
    )

    field(:name, :string)
    field(:material_cost, Money.Ecto.Amount.Type)
    field(:overhead_cost, Money.Ecto.Amount.Type)
    field(:total_cost, Money.Ecto.Amount.Type)
    field(:quantity, :integer)
    field(:depleted_at, :utc_datetime)
    timestamps()
  end

  @required_attrs ~w[
    name
    material_cost
    overhead_cost
    total_cost
    quantity
    order_id
  ]a
  @optional_attrs ~w[depleted_at]a
  @attrs @required_attrs ++ @optional_attrs
  def changeset(ingredient, attrs \\ %{}) do
    ingredient
    |> cast(attrs, @attrs)
    |> calculate_total_cost()
    |> validate_required(@required_attrs)
  end

  defp calculate_total_cost(%Ecto.Changeset{valid?: false} = changeset),
    do: changeset

  defp calculate_total_cost(changeset) do
    material_cost = get_field(changeset, :material_cost)
    overhead_cost = get_field(changeset, :overhead_cost)

    if material_cost && overhead_cost do
      total_cost = Money.add(material_cost, overhead_cost)
      put_change(changeset, :total_cost, total_cost)
    else
      changeset
    end
  end
end
