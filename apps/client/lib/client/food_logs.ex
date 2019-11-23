defmodule Client.FoodLogs do
  alias Client.FoodLogs.FoodLog
  alias Client.FoodLogs.Query
  alias Client.Repo

  def changeset(log, params \\ %{}),
    do: FoodLog.changeset(log, params)

  def new_changeset,
    do: FoodLog.changeset(%FoodLog{})

  def create(params) do
    %FoodLog{}
    |> FoodLog.changeset(params)
    |> Repo.insert()
  end

  def get(id), do: Repo.get(FoodLog, id)

  def list_by_owner_id(owner_id) do
    FoodLog
    |> Query.by_owner_id(owner_id)
    |> Repo.all()
  end

  def delete(id) do
    id |> get() |> Repo.delete()
  end
end
