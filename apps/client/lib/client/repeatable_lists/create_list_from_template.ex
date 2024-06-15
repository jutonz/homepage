defmodule Client.RepeatableLists.CreateListFromTemplate do
  import Ecto.Query, only: [from: 2]
  alias Client.RepeatableLists
  alias Client.Repo

  alias Client.RepeatableLists.{
    List,
    Section,
    TemplateItem,
    TemplateSection
  }

  def perform(template, list_params) do
    list_params =
      Map.merge(list_params, %{
        "template_id" => template.id,
        "name" => list_params["name"] || template.name,
        "description" => list_params["description"] || template.description
      })

    Repo.transaction(fn ->
      {:ok, list} =
        %List{}
        |> RepeatableLists.list_changeset(list_params)
        |> Repo.insert()

      {:ok, _result} =
        template
        |> section_attrs(list)
        |> Enum.reduce(Ecto.Multi.new(), fn section_cset, multi ->
          Ecto.Multi.insert(multi, :rand.uniform(), section_cset)
        end)
        |> Repo.transaction()

      {:ok, _result} =
        template
        |> item_attrs(list)
        |> Enum.reduce(Ecto.Multi.new(), fn item_cset, multi ->
          Ecto.Multi.insert(multi, :rand.uniform(), item_cset)
        end)
        |> Repo.transaction()

      list
    end)
  end

  defp section_attrs(template, list) do
    from(
      ts in TemplateSection,
      where: ts.template_id == ^template.id,
      select: %{
        name: ts.name,
        template_id: ts.template_id,
        template_section_id: ts.id
      }
    )
    |> Repo.all()
    |> Enum.map(fn attrs ->
      attrs
      |> Map.put(:list_id, list.id)
      |> RepeatableLists.new_section_changeset()
    end)
  end

  defp item_attrs(template, list) do
    from(
      ti in TemplateItem,
      where: ti.template_id == ^template.id,
      left_join: ts in assoc(ti, :section),
      left_join: s in Section,
      on: s.template_section_id == ts.id,
      select: %{
        name: ti.name,
        template_id: ti.template_id,
        section_id: s.id
      }
    )
    |> Repo.all()
    |> Enum.map(fn attrs ->
      attrs
      |> Map.put(:list_id, list.id)
      |> RepeatableLists.new_item_changeset()
    end)
  end
end
