defmodule Client.Storage do
  alias Client.{
    Repo,
    Storage.Context,
    Storage.ContextQuery,
    Storage.Item,
    Storage.ItemQuery
  }

  import Ecto.Query, only: [from: 2]

  ##############################################################################
  # Index
  ##############################################################################

  def list_contexts(user_id) do
    Context
    |> ContextQuery.by_user_id(user_id)
    |> Repo.all()
  end

  def list_items(user_id, context_id) do
    Item
    |> ItemQuery.by_user_id(user_id)
    |> ItemQuery.by_context_id(context_id)
    |> Repo.all()
  end

  ##############################################################################
  # Changesets
  ##############################################################################

  def context_changeset(context, attrs \\ %{}) do
    Context.changeset(context, attrs)
  end

  def new_context_changeset(attrs \\ %{}) do
    context_changeset(%Context{}, attrs)
  end

  def item_changeset(item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

  def new_item_changeset(attrs \\ %{}) do
    item_changeset(%Item{}, attrs)
  end

  ##############################################################################
  # Create
  ##############################################################################

  def create_context(user_id, attrs) do
    attrs
    |> Map.put("teams", team_names_to_teams(user_id, attrs["team_names"]))
    |> new_context_changeset()
    |> Repo.insert()
  end

  def create_item(attrs) do
    attrs
    |> new_item_changeset()
    |> Repo.insert()
  end

  ##############################################################################
  # Get
  ##############################################################################

  def get_context(user_id, id) do
    Context
    |> ContextQuery.by_user_id(user_id)
    |> ContextQuery.by_id(id)
    |> Repo.one()
  end

  def get_item(user_id, context_id, id) do
    Item
    |> ItemQuery.by_user_id(user_id)
    |> ItemQuery.by_context_id(context_id)
    |> ItemQuery.by_id(id)
    |> Repo.one()
  end

  ##############################################################################
  # Update
  ##############################################################################

  def update_context(user_id, context, attrs) do
    attrs =
      attrs
      |> Map.delete("team_names")
      |> Map.put("teams", team_names_to_teams(user_id, attrs["team_names"]))

    context
    |> context_changeset(attrs)
    |> Repo.update()
  end

  def update_item(item, attrs) do
    item |> item_changeset(attrs) |> Repo.update()
  end

  defp team_names_to_teams(user_id, team_names) do
    if team_names && Enum.any?(team_names) do
      query =
        from(
          t in Client.Team,
          join: ut in "user_teams",
          on: ut.user_id == ^user_id,
          where: t.name in ^team_names,
          distinct: true
        )

      Repo.all(query)
    else
      []
    end
  end

  ##############################################################################
  # Delete
  ##############################################################################

  def delete_item(item) do
    Repo.delete(item)
  end

  ##############################################################################
  # Other
  ##############################################################################

  def search_items(user_id, context_id, search) do
    Item
    |> ItemQuery.by_user_id(user_id)
    |> ItemQuery.by_context_id(context_id)
    |> ItemQuery.search(search)
    |> ItemQuery.order_by_name()
    |> Repo.all()
  end
end
