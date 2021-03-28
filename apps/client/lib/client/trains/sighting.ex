defmodule Client.Trains.Sighting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "train_sightings" do
    belongs_to(:log, Client.Trains.Log)
    field(:sighted_at, :utc_datetime)
    field(:direction, :string)
    field(:cars, :integer)
    timestamps(type: :utc_datetime)
  end

  @required_params ~w[
    cars
    direction
    log_id
    sighted_at
  ]a

  def changeset(sighting, params) do
    sighting
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
