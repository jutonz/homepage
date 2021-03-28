defmodule Client.Trains do
  import Ecto.Query, only: [from: 2]

  alias Client.{
    Repo,
    Trains.CreateSighting,
    Trains.Engine,
    Trains.Log
  }

  def create_log(params) do
    %Log{} |> Log.changeset(params) |> Repo.insert()
  end

  def list_logs(user_id) do
    query = from(log in Log, where: log.user_id == ^user_id)
    Repo.all(query)
  end

  def create_engine(params) do
    %Engine{} |> Engine.changeset(params) |> Repo.insert()
  end

  def get_engine_by_number(number) do
    Repo.get_by(Engine, number: number)
  end

  defdelegate create_sighting(params), to: CreateSighting
end
