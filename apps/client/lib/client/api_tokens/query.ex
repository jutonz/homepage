defmodule Client.ApiTokens.Query do
  import Ecto.Query, only: [from: 2]

  def by_user_id(query, user_id) do
    from(token in query, where: token.user_id == ^user_id)
  end

  def by_description(query, description) do
    from(token in query, where: token.description == ^description)
  end

  def by_token(query, token) do
    from(token in query, where: token.token == ^token)
  end
end
