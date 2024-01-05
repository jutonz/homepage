defmodule Client.RepeatableLists do
  import Ecto.Query, only: [from: 2]
  alias Client.Repo
  alias Client.RepeatableLists.Template

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

  ##############################################################################
  # Index
  ##############################################################################

  def create_template(user_id, attrs) do
    attrs
    |> Map.put("owner_id", user_id)
    |> new_template_changeset()
    |> Repo.insert()
  end
end
