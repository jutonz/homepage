defmodule Client.FoodLogs do
  alias Client.FoodLogs.Entry
  alias Client.FoodLogs.FoodLog
  alias Client.FoodLogs.Query
  alias Client.Repo

  def changeset(log, params \\ %{}),
    do: FoodLog.changeset(log, params)

  def entry_changeset(entry, params \\ %{}),
    do: Entry.changeset(entry, params)

  def new_changeset,
    do: FoodLog.changeset(%FoodLog{})

  def create(params),
    do: %FoodLog{} |> FoodLog.changeset(params) |> Repo.insert()

  def create_entry(params),
    do: %Entry{} |> Entry.changeset(params) |> Repo.insert()

  def get(id),
    do: Repo.get(FoodLog, id)

  def list_by_owner_id(owner_id),
    do: FoodLog |> Query.by_owner_id(owner_id) |> Repo.all()

  def list_entries(log_id),
    do: Entry |> Entry.Query.by_log(log_id) |> Repo.all()

  def update(log, params),
    do: log |> changeset(params) |> Repo.update()

  def delete(id),
    do: id |> get() |> Repo.delete()
end
