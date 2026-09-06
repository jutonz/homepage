defmodule Client.FoodLogs.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "food_log_entries" do
    field(:description, :string)
    field(:food_log_id, Ecto.UUID)
    field(:user_id, :integer)
    field(:occurred_at, :naive_datetime)
    timestamps()
  end

  def changeset(entry, params \\ %{}) do
    entry
    |> cast(params, ~w[description occurred_at]a)
    |> validate_required(~w[description food_log_id user_id occurred_at]a)
  end
end
