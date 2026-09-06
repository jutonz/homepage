defmodule Client.FoodLogs.Entry.Query do
  import Ecto.Query, only: [from: 2]

  alias Client.FoodLogs.FoodLog
  alias Client.Scope

  @doc """
  Entries whose parent log the scope owns.

  Ownership travels through the log. The user id on the entry records who
  logged the food and says nothing about who may read it.
  """
  def owned_by(query, %Scope{user: user}) do
    from(entry in query,
      join: log in ^FoodLog,
      on: log.id == entry.food_log_id,
      where: log.owner_id == ^user.id
    )
  end

  def by_ids(query, ids),
    do: from(entry in query, where: entry.id in ^ids)

  def in_log(query, log_id),
    do: from(entry in query, where: entry.food_log_id == ^log_id)

  def occurred_between(query, start_time, end_time) do
    from(entry in query,
      where: entry.occurred_at >= ^start_time,
      where: entry.occurred_at <= ^end_time,
      order_by: [asc: entry.occurred_at]
    )
  end
end
