defmodule Client.RepeatableLists do
  import Ecto.Query, only: [from: 2]
  alias Client.Repo

  alias Client.RepeatableLists.{
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
    attrs = Map.put(attrs, "template_id", template_id) |> IO.inspect()

    %TemplateSection{}
    |> template_section_changeset(attrs)
    |> Repo.insert()
  end

  ##############################################################################
  # Get
  ##############################################################################

  def get_template(user_id, id) do
    query =
      from(t in Template,
        where: t.owner_id == ^user_id,
        where: t.id == ^id,
        preload: [:items, :sections]
      )

    Repo.one(query)
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

  ##############################################################################
  # Delete
  ##############################################################################

  def delete_template(template = %Template{}),
    do: Repo.delete(template)
end
