defmodule Client.WaterLogs do
  import Ecto.Query, only: [from: 2]

  alias Client.{
    Repo,
    WaterLogs.AmountQuery,
    WaterLogs.Entry,
    WaterLogs.Filter,
    WaterLogs.WaterLog
  }

  def changeset(log, params \\ %{}),
    do: WaterLog.changeset(log, params)

  def entry_changeset(entry, params \\ %{}),
    do: Entry.changeset(entry, params)

  def filter_changeset(filter, params \\ %{}),
    do: Filter.changeset(filter, params)

  def new_filter_changeset(),
    do: Filter.changeset(%Filter{}, %{})

  def new_changeset,
    do: changeset(%WaterLog{})

  def create(params),
    do: %WaterLog{} |> changeset(params) |> Repo.insert()

  def create_entry(params),
    do: %Entry{} |> entry_changeset(params) |> Repo.insert()

  def create_filter(params),
    do: %Filter{} |> filter_changeset(params) |> Repo.insert()

  def get(id),
    do: Repo.get(WaterLog, id)

  def get_by_user_id(user_id, id) do
    Repo.get_by(WaterLog, id: id, user_id: user_id)
  end

  def get_filter(id),
    do: Repo.get(Filter, id)

  def get_current_filter(log_id) do
    query =
      from(
        filter in Filter,
        where: filter.water_log_id == ^log_id,
        order_by: [desc: filter.inserted_at],
        limit: 1
      )

    Repo.one(query)
  end

  def get_amount_dispensed(id, opts \\ []),
    do: AmountQuery.get_amount_dispensed(id, opts)

  def list_by_user_id(user_id) do
    query = from(log in WaterLog, where: log.user_id == ^user_id)
    Repo.all(query)
  end

  def list_entries_by_log_id(log_id) do
    query =
      from(
        entry in Entry,
        where: entry.water_log_id == ^log_id,
        order_by: [desc: entry.inserted_at]
      )

    Repo.all(query)
  end

  def list_filters_by_log_id(log_id) do
    Repo.all(
      from(
        filter in Filter,
        where: filter.water_log_id == ^log_id,
        order_by: [asc: filter.inserted_at]
      )
    )
  end

  def update_filter(filter, params) do
    filter |> filter_changeset(params) |> Repo.update()
  end

  def delete_filter(id),
    do: id |> get_filter() |> Repo.delete()
end
