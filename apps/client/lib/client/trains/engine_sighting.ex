defmodule Client.Trains.EngineSighting do
  use Ecto.Schema
  import Ecto.Changeset

  alias Client.{
    Trains.Engine,
    Trains.Sighting
  }

  schema "train_engine_sightings" do
    belongs_to(:engine_id, Engine)
    belongs_to(:sighting_id, Sighting)
    timestamps(type: :utc_datetime)
  end

  @required_params ~w[engine_id sighting_id]a

  def changeset(engine, params) do
    engine
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
