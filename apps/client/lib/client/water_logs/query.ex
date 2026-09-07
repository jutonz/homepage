defmodule Client.WaterLogs.Query do
  import Ecto.Query, only: [from: 2]

  alias Client.Scope

  def owned_by(query, %Scope{user: user}),
    do: from(log in query, where: log.user_id == ^user.id)
end
