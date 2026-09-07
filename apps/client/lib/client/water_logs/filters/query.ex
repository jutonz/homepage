defmodule Client.WaterLogs.Filter.Query do
  import Ecto.Query, only: [from: 2]

  alias Client.Scope
  alias Client.WaterLogs.WaterLog

  @doc """
  Filters whose parent log the scope owns.

  A filter carries no owner of its own, so the log it is fitted to is the only
  path to one.
  """
  def owned_by(query, %Scope{user: user}) do
    from(filter in query,
      join: log in WaterLog,
      on: log.id == filter.water_log_id,
      where: log.user_id == ^user.id
    )
  end

  def in_log(query, log_id),
    do: from(filter in query, where: filter.water_log_id == ^log_id)

  def oldest_first(query),
    do: from(filter in query, order_by: [asc: filter.inserted_at])

  def most_recent(query),
    do: from(filter in query, order_by: [desc: filter.inserted_at], limit: 1)
end
