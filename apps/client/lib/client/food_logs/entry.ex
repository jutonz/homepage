defmodule Client.FoodLogs.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "food_log_entries" do
    field(:description, :string)
    field(:food_log_id, Ecto.UUID)
    field(:user_id, :integer)
    timestamps()
  end

  def changeset(entry, params \\ %{}) do
    entry
    |> cast(params, optional_attrs() ++ required_attrs())
    |> validate_required(required_attrs())
  end

  defp optional_attrs, do: []
  defp required_attrs, do: ~w[description food_log_id user_id]a
end
