defmodule Client.Trains.CreateSighting do
  alias Client.{
    Repo,
    Trains,
    Trains.Sighting
  }

  def create_sighting(params) do
    engine_params = %{
      number: Map.fetch!(params, :number),
      user_id: Map.fetch!(params, :user_id)
    }

    Repo.transaction(fn ->
      with {:ok, _engine} <- ensure_engine(engine_params),
           {:ok, sighting} <- insert_sighting(params) do
        # TODO: Insert engine sighting
        sighting
      else
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  defp ensure_engine(%{number: number} = params) do
    case Trains.get_engine_by_number(number) do
      nil -> Trains.create_engine(params)
      train -> {:ok, train}
    end
  end

  defp insert_sighting(params) do
    %Sighting{} |> Sighting.changeset(params) |> Repo.insert()
  end
end
