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

  def get_entry(id),
    do: Repo.get(Entry, id)

  def list_by_owner_id(owner_id),
    do: FoodLog |> Query.by_owner_id(owner_id) |> Repo.all()

  def list_entries_by_day(log_id),
    do: Entry.Query.grouped_by_day(log_id)

  def update(log, params),
    do: log |> changeset(params) |> Repo.update()

  def update_entry(entry, params),
    do: entry |> entry_changeset(params) |> Repo.update()

  def delete(id),
    do: id |> get() |> Repo.delete()

  def delete_entry(id),
    do: id |> get_entry() |> Repo.delete()
end
