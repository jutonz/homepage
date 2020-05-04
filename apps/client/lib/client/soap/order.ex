defmodule Client.Soap.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "soap_orders" do
    belongs_to(:user, Client.User)
    has_many(:ingredients, Client.Soap.Ingredient)
    field(:name, :string)
    field(:shipping_cost, Money.Ecto.Amount.Type)
    field(:tax, Money.Ecto.Amount.Type)
    timestamps()
  end

  def changeset(order, attrs \\ %{}) do
    order
    |> cast(attrs, ~w[name shipping_cost tax user_id]a)
    |> validate_required(~w[name shipping_cost tax user_id]a)
  end
end
