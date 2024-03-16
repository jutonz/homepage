defmodule Client.RepeatableLists do
  import Ecto.Query, only: [from: 2]
  alias Client.Repo

  alias Client.RepeatableLists.{
    Item,
    List,
    Section,
    Template,
    TemplateItem,
    TemplateSection
  }

  ##############################################################################
  # Index
  ##############################################################################

  def list_templates(user_id) do
    query = from(t in Template, where: t.owner_id == ^user_id)
    Repo.all(query)
  end

  ##############################################################################
  # Changesets
  ##############################################################################

  def new_template_changeset(attrs \\ %{}),
    do: Template.changeset(%Template{}, attrs)

  def template_changeset(template, attrs \\ %{}),
    do: Template.changeset(template, attrs)

  def list_changeset(list, attrs \\ %{}),
    do: List.changeset(list, attrs)

  def new_item_changeset(attrs \\ %{}),
    do: Item.changeset(%Item{}, attrs)

  def item_changeset(item, attrs \\ %{}),
    do: Item.changeset(item, attrs)

  def new_section_changeset(attrs \\ %{}),
    do: Section.changeset(%Section{}, attrs)

  def new_template_item_changeset(attrs \\ %{}),
    do: TemplateItem.changeset(%TemplateItem{}, attrs)

  def template_item_changeset(item, attrs \\ %{}),
    do: TemplateItem.changeset(item, attrs)

  def new_template_section_changeset(attrs \\ %{}),
    do: TemplateSection.changeset(%TemplateSection{}, attrs)

  def template_section_changeset(section, attrs \\ %{}),
    do: TemplateSection.changeset(section, attrs)

  ##############################################################################
  # Create
  ##############################################################################

  def create_template(user_id, attrs) do
    attrs
    |> Map.put("owner_id", user_id)
    |> new_template_changeset()
    |> Repo.insert()
  end

  def create_template_item(template_id, attrs) do
    attrs
    |> Map.put("template_id", template_id)
    |> new_template_item_changeset()
    |> Repo.insert()
  end

  def create_template_section(template_id, attrs) do
    attrs = Map.put(attrs, "template_id", template_id)

    %TemplateSection{}
    |> template_section_changeset(attrs)
    |> Repo.insert()
  end

  def create_item(list_id, attrs) do
    attrs
    |> Map.put("list_id", list_id)
    |> new_item_changeset()
    |> Repo.insert()
  end

  defdelegate create_list_from_template(template),
    to: Client.RepeatableLists.CreateListFromTemplate,
    as: :perform

  ##############################################################################
  # Get
  ##############################################################################

  def get_template(user_id, id) do
    from(t in Template,
      where: t.owner_id == ^user_id,
      where: t.id == ^id
    )
    |> Repo.one()
    |> Repo.preload(
      lists: [],
      items: from(i in TemplateItem, where: is_nil(i.section_id)),
      sections: :items
    )
  end

  def get_list(user_id, id) do
    from(l in List,
      join: t in Template,
      on: l.template_id == t.id,
      where: t.owner_id == ^user_id,
      where: l.id == ^id
    )
    |> Repo.one()
    |> Repo.preload(
      items: from(i in Item, where: is_nil(i.section_id)),
      sections: [items: from(i in Item, order_by: i.inserted_at)],
      template: from(t in Template, order_by: t.inserted_at)
    )
  end

  ##############################################################################
  # Update
  ##############################################################################

  def update_template_item(item, attrs) do
    # TODO: prevent changing template_id?
    item
    |> template_item_changeset(attrs)
    |> Repo.update()
  end

  def update_item(item, attrs) do
    # TODO: prevent changing template_id?
    item
    |> item_changeset(attrs)
    |> Repo.update()
  end

  ##############################################################################
  # Delete
  ##############################################################################

  def delete_template(template = %Template{}),
    do: Repo.delete(template)
end
