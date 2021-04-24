defmodule Client.Trains.Engine do
  use Ecto.Schema
  import Ecto.Changeset

  schema "train_engines" do
    belongs_to(:user, Client.User)
    has_many(:engine_sightings, Client.Trains.EngineSighting)
    has_many(:sightings, through: [:engine_sightings, :sighting])
    field(:number, :integer)
    timestamps(type: :utc_datetime)
  end

  @required_params ~w[number user_id]a

  def changeset(engine, params) do
    engine
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint(:number, name: :train_engines_number_index)
  end
end
