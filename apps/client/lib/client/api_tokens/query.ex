defmodule Client.ApiTokens.Query do
  import Ecto.Query, only: [from: 2]

  alias Client.Scope

  def owned_by(query, %Scope{user: user}) do
    from(token in query, where: token.user_id == ^user.id)
  end

  def by_description(query, description) do
    from(token in query, where: token.description == ^description)
  end

  def by_token(query, token) do
    from(token in query, where: token.token == ^token)
  end
end
