defmodule Client.WaterLogs.WaterLog do
  use Ecto.Schema
  alias Client.WaterLogs.WaterLog

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "water_logs" do
    field(:name, :string)
    field(:user_id, :integer)
    timestamps()
  end

  def changeset(%WaterLog{} = log, attrs \\ %{}) do
    log
    |> Ecto.Changeset.cast(attrs, ~w[name user_id]a)
    |> Ecto.Changeset.validate_required(~w[name user_id]a)
    |> Ecto.Changeset.unique_constraint(:name, name: :water_logs_user_id_name_index)
  end
end
