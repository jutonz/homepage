defmodule Client.FoodLogs.Query do
  import Ecto.Query, only: [from: 2]

  def by_owner_id(query, owner_id) do
    from(log in query, where: log.owner_id == ^owner_id)
  end
end
