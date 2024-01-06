defmodule ClientWeb.RepeatableListsTest do
  use ClientWeb.FeatureCase
  alias Client.RepeatableLists

  test "can create a list template", %{session: session} do
    user = insert(:user)

    session
    |> visit("/repeatable-lists?as=#{user.id}")
    |> click(link("New list template"))
    |> fill_in(text_field("Name"), with: "name")
    |> fill_in(text_field("Description"), with: "desc")
    |> click(button("Create"))
    |> assert_has(role("name", text: "name"))

    [template] = RepeatableLists.list_templates(user.id)

    assert %RepeatableLists.Template{
             name: "name",
             description: "desc"
           } = template
  end

  test "can delete a template", %{session: session} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)

    session
    |> visit("/repeatable-lists?as=#{user.id}")
    |> click(link(template.name))
    |> click(button("Delete template"))
    |> find(css("[role=dialog]"), fn modal ->
      modal |> click(button("Delete template"))
    end)
    |> assert_has(role("flash-info", text: "Deleted template"))
  end
end
