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
    |> assert_has(role("list-template", text: "name"))

    [template] = RepeatableLists.list_templates(user.id)

    assert %RepeatableLists.Template{
             name: "name",
             description: "desc"
           } = template
  end
end
