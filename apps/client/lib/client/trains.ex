defmodule Client.Trains do
  import Ecto.Query, only: [from: 2]

  alias Client.{
    Repo,
    Trains.CreateSighting,
    Trains.Engine,
    Trains.Log,
    Trains.Sighting
  }

  ##############################################################################
  # Logs
  ##############################################################################

  def new_log_changeset(params \\ %{}) do
    log_changeset(%Log{}, params)
  end

  def log_changeset(log, params) do
    Log.changeset(log, params)
  end

  def create_log(params) do
    %Log{} |> Log.changeset(params) |> Repo.insert()
  end

  def get_log(user_id, log_id) do
    query =
      from(
        log in Log,
        where: log.user_id == ^user_id,
        where: log.id == ^log_id
      )

    Repo.one(query)
  end

  def list_logs(user_id) do
    query = from(log in Log, where: log.user_id == ^user_id)
    Repo.all(query)
  end

  ##############################################################################
  # Engines
  ##############################################################################

  def create_engine(params) do
    %Engine{} |> Engine.changeset(params) |> Repo.insert()
  end

  def get_engine_by_number(number) do
    Repo.get_by(Engine, number: number)
  end

  ##############################################################################
  # Sightings
  ##############################################################################

  def new_sighting_changeset(params \\ %{}) do
    sighting_changeset(%Sighting{}, params)
  end

  def sighting_changeset(sighting, params) do
    Sighting.changeset(sighting, params)
  end

  defdelegate create_sighting(params), to: CreateSighting

  def list_sightings(log_id) do
    query = from(
      s in Sighting,
      where: s.log_id == ^log_id,
      order_by: [desc: s.sighted_at]
    )

    query
    |> Repo.all()
    |> Repo.preload(:engines)
  end
end
