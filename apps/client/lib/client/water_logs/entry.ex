defmodule Client.WaterLogs.Entry do
  use Ecto.Schema
  alias Client.WaterLogs.Entry

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "water_log_entries" do
    field(:ml, :integer)
    field(:user_id, :integer)
    field(:water_log_id, Ecto.UUID)
    timestamps()
  end

  def changeset(%Entry{} = entry, attrs \\ %{}) do
    entry
    |> Ecto.Changeset.cast(attrs, ~w[ml user_id water_log_id]a)
    |> Ecto.Changeset.validate_required(~w[ml user_id water_log_id]a)
  end
end
