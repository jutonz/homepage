defmodule Client.Trains.CreateSighting do
  import Ecto.Changeset
  alias Client.{
    Repo,
    Trains,
    Trains.EngineSighting,
    Trains.Sighting
  }

  @type params :: %{
          cars: non_neg_integer(),
          direction: String.t(),
          log_id: String.t(),
          number: non_neg_integer(),
          sighted_at: DateTime.t(),
          user_id: pos_integer()
        }

  @spec create_sighting(params :: params()) ::
          {:ok, Sighting.t()}
          | {:error, Ecto.Changeset.t()}

  def create_sighting(params) do
    %Sighting{}
    |> Sighting.changeset(params)
    |> IO.inspect()
    |> insert()
  end

  defp insert(%Ecto.Changeset{valid?: false} = changeset) do
    changeset = Map.put(changeset, :action, :insert)
    {:error, changeset}
  end

  defp insert(changeset) do
    Repo.transaction(fn ->
      with {:ok, engines} <- ensure_engines(changeset),
           {:ok, sighting} <- Repo.insert(changeset),
           {:ok, _engine_sighting} <- insert_engine_sighting(engine.id, sighting.id) do
        sighting
      else
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  defp ensure_engines(changeset) do
    numbers = fetch_change!(changeset, :numbers)
    user_id = fetch_change!(changeset, :user_id)

    Enum.each(numbers, fn number ->
      ensure_engine(%{number: number, user_id: user_id})
    end)
  end

  defp ensure_engine(%{number: number} = params) do
    case Trains.get_engine_by_number(number) do
      nil -> Trains.create_engine(params)
      train -> {:ok, train}
    end
  end

  defp insert_engine_sighting(engine_id, sighting_id) do
    params = %{engine_id: engine_id, sighting_id: sighting_id}
    %EngineSighting{} |> EngineSighting.changeset(params) |> Repo.insert()
  end
end
