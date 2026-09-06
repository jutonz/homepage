defmodule Client.FoodLogs.Entry.Query do
  import Ecto.Query, only: [from: 2]

  def by_ids(query, ids),
    do: from(entry in query, where: entry.id in ^ids)
end
