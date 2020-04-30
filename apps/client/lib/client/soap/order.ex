defmodule Client.Soap.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "soap_orders" do
    belongs_to(:user, Client.User)
    field(:name, :string)
    field(:shipping_cost, :integer)
    timestamps()
  end

  def changeset(order, attrs \\ %{}) do
    order
    |> cast(attrs, ~w[name shipping_cost user_id]a)
    |> validate_required(~w[name shipping_cost user_id]a)
  end
end
