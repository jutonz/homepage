defmodule Client.FoodLogs.FoodLog do
  use Ecto.Schema
  alias Client.FoodLogs.FoodLog

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "food_logs" do
    field(:name, :string)
    field(:description, :string)
    field(:owner_id, :integer)
    timestamps()
  end

  def changeset(%FoodLog{} = log, attrs \\ %{}) do
    log
    |> Ecto.Changeset.cast(attrs, ~w[name description owner_id]a)
    |> Ecto.Changeset.validate_required(~w[name owner_id]a)
    |> Ecto.Changeset.unique_constraint(:name, name: :food_logs_owner_id_name_index)
  end
end
