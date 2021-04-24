defmodule Client.Trains.CreateSighting do
  import Ecto.Changeset

  alias Client.{
    Repo,
    Trains,
    Trains.EngineSighting,
    Trains.Sighting
  }

  @spec create_sighting(map()) ::
          {:ok, list(Sighting.t())}
          | {:error, Ecto.Changeset.t()}

  def create_sighting(params) do
    %Sighting{}
    |> Sighting.changeset(params)
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
           {:ok, _engine_sightings} <- insert_engine_sightings(engines, sighting.id) do
        sighting
      else
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  defp ensure_engines(changeset) do
    numbers = fetch_change!(changeset, :numbers)
    user_id = fetch_change!(changeset, :user_id)

    engines =
      Enum.map(numbers, fn number ->
        case ensure_engine(%{number: number, user_id: user_id}) do
          {:ok, engine} -> engine
          {:error, changeset} -> {:error, changeset}
        end
      end)

    first_error =
      Enum.find(engines, fn
        {:error, _changeset} -> true
        _engine -> false
      end)

    if first_error do
      first_error
    else
      {:ok, engines}
    end
  end

  defp ensure_engine(%{number: number} = params) do
    case Trains.get_engine_by_number(number) do
      nil -> Trains.create_engine(params)
      train -> {:ok, train}
    end
  end

  defp insert_engine_sightings(engines, sighting_id) do
    sightings = Enum.map(engines, &insert_engine_sighting(&1.id, sighting_id))

    first_error =
      Enum.find(sightings, fn
        {:ok, _sighting} -> false
        {:error, _changeset} -> true
      end)

    if first_error do
      first_error
    else
      {:ok, sightings}
    end
  end

  defp insert_engine_sighting(engine_id, sighting_id) do
    params = %{engine_id: engine_id, sighting_id: sighting_id}
    %EngineSighting{} |> EngineSighting.changeset(params) |> Repo.insert()
  end
end
