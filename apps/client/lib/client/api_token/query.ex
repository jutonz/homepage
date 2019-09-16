defmodule Client.ApiToken.Query do
  import Ecto.Query, only: [from: 2]

  def by_user_id(query, user_id) do
    from(token in query, where: token.user_id == ^user_id)
  end
end
