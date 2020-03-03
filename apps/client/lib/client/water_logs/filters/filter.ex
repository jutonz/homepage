defmodule Client.WaterLogs.Filter do
  use Ecto.Schema
  alias Client.WaterLogs.Filter

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "water_log_filters" do
    field(:water_log_id, Ecto.UUID)
    timestamps()
  end

  def changeset(%Filter{} = filter, attrs \\ %{}) do
    filter
    |> Ecto.Changeset.cast(attrs, ~w[water_log_id]a)
    |> Ecto.Changeset.validate_required(~w[water_log_id]a)
  end
end
