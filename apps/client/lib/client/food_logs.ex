defmodule Client.FoodLogs do
  alias Client.FoodLogs.FoodLog
  alias Client.FoodLogs.Query
  alias Client.Repo

  def new_changeset do
    FoodLog.changeset(%FoodLog{})
  end

  def create(params) do
    %FoodLog{}
    |> FoodLog.changeset(params)
    |> Repo.insert()
  end

  def get(id), do: Repo.get(FoodLog, id)

  def by_owner_id(owner_id) do
    FoodLog
    |> Query.by_owner_id(owner_id)
    |> Repo.all()
  end

  def delete(id) do
    id |> get() |> Repo.delete()
  end
end
