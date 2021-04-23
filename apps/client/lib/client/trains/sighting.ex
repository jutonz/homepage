defmodule Client.Trains.Sighting do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          cars: non_neg_integer(),
          direction: String.t(),
          log_id: String.t(),
          sighted_at: DateTime.t()
        }

  schema "train_sightings" do
    belongs_to(:log, Client.Trains.Log)
    has_many(:engine_sightings, Client.Trains.EngineSighting)
    has_many(:engines, through: [:engine_sightings, :engine])
    field(:sighted_at, :utc_datetime)
    field(:direction, :string)
    field(:cars, :integer)
    timestamps(type: :utc_datetime)

    field(:sighted_date, :date, virtual: true)
    field(:sighted_time, :time, virtual: true)
    field(:user_id, :id, virtual: true)
    field(:numbers, {:array, :integer}, virtual: true)
  end

  @required_params ~w[
    cars
    direction
    log_id
    sighted_at
    numbers
    user_id
    sighted_date
    sighted_time
  ]a

  @optional_params ~w[
  ]a

  @params @required_params ++ @optional_params

  def changeset(sighting, params) do
    sighting
    |> cast(params, @params)
    |> update_sighted_at()
    |> validate_required(@required_params)
    |> validate_inclusion(:direction, ~w[North South], message: "Must be North or South")
  end

  defp update_sighted_at(changeset) do
    date = get_change(changeset, :sighted_date)
    time = get_change(changeset, :sighted_time)

    if date && time do
      {:ok, naive} = NaiveDateTime.new(date, time)
      timezone = Application.fetch_env!(:client, :default_timezone)

      datetime =
        naive
        |> DateTime.from_naive!(timezone)
        |> DateTime.shift_zone!("Etc/UTC")

      put_change(changeset, :sighted_at, datetime)
    else
      changeset
    end
  end
end
