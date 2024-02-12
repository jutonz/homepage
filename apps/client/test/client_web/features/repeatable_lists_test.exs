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

  test "can add an item to a template", %{session: session} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)

    session
    |> visit("/repeatable-lists/templates/#{template.id}?as=#{user.id}")
    |> click(button("+ Add item"))
    |> fill_in(text_field("Name"), with: "Item name")
    |> send_keys([:enter])
    |> assert_has(role("item-form"))

    template = Repo.preload(template, :items)
    [item] = template.items

    assert %RepeatableLists.TemplateItem{
             name: "Item name"
           } = item
  end

  test "can edit an item in a template", %{session: session} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)
    item = insert(:repeatable_list_template_item, template: template, name: "before")

    session
    |> visit("/repeatable-lists/templates/#{template.id}?as=#{user.id}")
    |> fill_in(text_field("name"), with: "after")
    |> send_keys([:enter])

    Client.RetryHelpers.wait_until(3000, fn ->
      assert %{name: "after"} = Client.Repo.reload(item)
    end)
  end

  test "can add a section to a template", %{session: session} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)

    session
    |> visit("/repeatable-lists/templates/#{template.id}?as=#{user.id}")
    |> click(button("+ Add section"))
    |> fill_in(text_field("Name"), with: "Section name")
    |> send_keys([:enter])
    |> assert_text("Section: Section name")

    template = Repo.preload(template, :sections)
    [section] = template.sections

    assert %RepeatableLists.TemplateSection{
             name: "Section name"
           } = section
  end
end
