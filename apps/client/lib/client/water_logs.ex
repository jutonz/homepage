defmodule Client.WaterLogs do
  alias Client.Repo
  alias Client.WaterLogs.WaterLog
  alias Client.WaterLogs.Entry
  import Ecto.Query, only: [from: 2]

  def changeset(log, params \\ %{}),
    do: WaterLog.changeset(log, params)

  def entry_changeset(entry, params \\ %{}),
    do: Entry.changeset(entry, params)

  def new_changeset,
    do: changeset(%WaterLog{})

  def create(params),
    do: %WaterLog{} |> changeset(params) |> Repo.insert()

  def create_entry(params),
    do: %Entry{} |> entry_changeset(params) |> Repo.insert()

  def get(id),
    do: Repo.get(WaterLog, id)

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
end
