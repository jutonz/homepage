defmodule Client.WaterLogs.Entry.Query do
  import Ecto.Query, only: [from: 2]

  alias Client.Scope
  alias Client.WaterLogs.WaterLog

  @doc """
  Entries whose parent log the scope owns.

  Ownership travels through the log. The user id on the entry records who
  dispensed the water and says nothing about who may read it.
  """
  def owned_by(query, %Scope{user: user}) do
    from(entry in query,
      join: log in WaterLog,
      on: log.id == entry.water_log_id,
      where: log.user_id == ^user.id
    )
  end

  def in_log(query, log_id),
    do: from(entry in query, where: entry.water_log_id == ^log_id)

  def newest_first(query),
    do: from(entry in query, order_by: [desc: entry.inserted_at])

  def dispensed_between(query, start_at, end_at) do
    from(entry in query,
      where: entry.inserted_at >= ^start_at,
      where: entry.inserted_at <= ^end_at
    )
  end

  def total_ml(query),
    do: from(entry in query, select: sum(entry.ml))
end
