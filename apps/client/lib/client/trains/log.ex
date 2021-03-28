defmodule Client.Trains.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "train_logs" do
    belongs_to(:user, Client.User)
    field(:location, :string)
    timestamps(type: :utc_datetime)
  end

  @required_params ~w[location user_id]a

  def changeset(log, params) do
    log
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint(:location, name: :train_logs_user_id_location_index)
  end
end
