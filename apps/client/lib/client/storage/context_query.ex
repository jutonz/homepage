defmodule Client.Storage.ContextQuery do
  import Ecto.Query, only: [from: 2]
  alias Client.Team

  def by_user_id(query, user_id) do
    from(
      c in query,
      left_join: ut in "user_teams",
      on: ut.user_id == ^user_id,
      left_join: t in Team,
      on: t.id == ut.team_id,
      left_join: sct in "storage_context_teams",
      on: sct.team_id == t.id,
      where: c.id == sct.context_id or c.creator_id == ^user_id,
      distinct: true,
      select: c
    )
  end

  def by_id(query, id) do
    from(c in query, where: c.id == ^id)
  end
end
