defmodule Client.FoodLogs do
  alias Client.FoodLogs.Entry
  alias Client.FoodLogs.FoodLog
  alias Client.FoodLogs.Query
  alias Client.Repo
  import Ecto.Query, only: [from: 2]

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

  def get_entries(ids),
    do: Entry |> Entry.Query.by_ids(ids) |> Repo.all()

  def list_by_owner_id(owner_id),
    do: FoodLog |> Query.by_owner_id(owner_id) |> Repo.all()

  def list_entries_by_day(log_id),
    do: Entry.Query.grouped_by_day(log_id)

  def list_entries_between_dates(log_id, start_time, end_time) do
    query =
      from(e in Entry,
        where: e.food_log_id == ^log_id,
        where: e.occurred_at >= ^start_time,
        where: e.occurred_at <= ^end_time,
        order_by: [asc: e.occurred_at]
      )

    Repo.all(query)
  end

  def update(log, params),
    do: log |> changeset(params) |> Repo.update()

  def update_entry(entry, params),
    do: entry |> entry_changeset(params) |> Repo.update()

  def delete(id),
    do: id |> get() |> Repo.delete()

  def delete_entry(id),
    do: id |> get_entry() |> Repo.delete()
end
