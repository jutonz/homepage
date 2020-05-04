defmodule Client.Soap.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset
  alias Client.Soap.Ingredient

  schema "soap_ingredients" do
    belongs_to(:order, Client.Soap.Order)
    many_to_many(
      :recipes,
      Client.Soap.Recipe,
      join_through: "soap_recipe_ingredients"
    )
    field(:name, :string)
    field(:cost, Money.Ecto.Amount.Type)
    field(:quantity, :integer)
    field(:unit, :string)
    timestamps()
  end

  def changeset(ingredient, attrs \\ %{}) do
    ingredient
    |> cast(attrs, ~w[name cost quantity unit order_id]a)
    |> validate_required(~w[name cost quantity unit order_id]a)
  end

  def cost_per_quantity(%Ingredient{cost: cost, quantity: quantity}) do
    cost |> Money.to_decimal() |> Decimal.div(quantity)
  end
end
