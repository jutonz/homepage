defmodule Client.RepeatableLists.CreateListFromTemplate do
  import Ecto.Query, only: [from: 2]
  alias Client.RepeatableLists
  alias Client.Repo

  alias Client.RepeatableLists.{
    List,
    TemplateItem,
    TemplateSection
  }

  def perform(template) do
    Repo.transaction(fn ->
      {:ok, list} =
        %List{}
        |> RepeatableLists.list_changeset(%{
          template_id: template.id,
          name: template.name,
          description: template.description
        })
        |> Repo.insert()

      {:ok, _result} =
        template
        |> item_attrs(list)
        |> Enum.reduce(Ecto.Multi.new(), fn item_cset, multi ->
          Ecto.Multi.insert(multi, :rand.uniform(), item_cset)
        end)
        |> Repo.transaction()

      {:ok, _result} =
        template
        |> section_attrs(list)
        |> Enum.reduce(Ecto.Multi.new(), fn section_cset, multi ->
          Ecto.Multi.insert(multi, :rand.uniform(), section_cset)
        end)
        |> Repo.transaction()

      list
    end)
  end

  defp item_attrs(template, list) do
    from(
      ti in TemplateItem,
      where: ti.template_id == ^template.id,
      select: %{
        name: ti.name,
        section_id: ti.section_id,
        template_id: ti.template_id
      }
    )
    |> Repo.all()
    |> Enum.map(fn attrs ->
      attrs
      |> Map.put(:list_id, list.id)
      |> RepeatableLists.new_item_changeset()
    end)
  end

  defp section_attrs(template, list) do
    from(
      ts in TemplateSection,
      where: ts.template_id == ^template.id,
      select: %{
        name: ts.name,
        template_id: ts.template_id
      }
    )
    |> Repo.all()
    |> Enum.map(fn attrs ->
      attrs
      |> Map.put(:list_id, list.id)
      |> RepeatableLists.new_section_changeset()
    end)
  end
end
