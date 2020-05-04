defmodule Client.Soap.Batch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "soap_batches" do
    belongs_to(:user, Client.User)
    many_to_many(
      :ingredients,
      Client.Soap.Ingredient,
      join_through: "soap_batch_ingredients"
    )
    field(:name, :string)
    timestamps()
  end

  def changeset(batch, attrs \\ %{}) do
    batch
    |> cast(attrs, ~w[name user_id]a)
    |> validate_required(~w[name user_id]a)
  end
end
