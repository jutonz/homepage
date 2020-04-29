defmodule Client.Soap.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "soap_recipes" do
    belongs_to(:user, Client.User)
    #has_many(:ingredients, Client.Soap.Ingredient)
    field(:name, :string)
    timestamps()
  end

  def changeset(recipe, attrs \\ %{}) do
    recipe
    |> cast(attrs, ~w[name user_id]a)
    |> validate_required(~w[name user_id]a)
  end
end
