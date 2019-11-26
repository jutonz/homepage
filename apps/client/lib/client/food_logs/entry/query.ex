defmodule Client.FoodLogs.Entry.Query do
  import Ecto.Query, only: [from: 2]

  def by_log(query, log_id),
    do: from(entry in query, where: entry.food_log_id == ^log_id)
end
