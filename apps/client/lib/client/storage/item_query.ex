defmodule Client.Storage.ItemQuery do
  import Ecto.Query, only: [from: 2]

  alias Client.{
    Storage.Context,
    Storage.ContextQuery
  }

  def by_user_id(query, user_id) do
    context_query = ContextQuery.by_user_id(Context, user_id)

    from(
      i in query,
      join: c in subquery(context_query),
      on: c.id == i.context_id
    )
  end

  def by_context_id(query, context_id) do
    context_query = ContextQuery.by_id(Context, context_id)

    from(
      i in query,
      join: c in subquery(context_query),
      on: c.id == ^context_id
    )
  end

  def by_id(query, id) do
    from(i in query, where: i.id == ^id)
  end

  def order_by_name(query) do
    from(i in query, order_by: :name)
  end
end
