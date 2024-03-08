defmodule ClientWeb.RepeatableLists.TemplatesLive.ShowTest do
  alias Client.RepeatableLists
  use ClientWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "renders the name and description", %{conn: conn} do
    user = insert(:user)

    template =
      insert(
        :repeatable_list_template,
        owner: user,
        name: "Name",
        description: "Description"
      )

    {:ok, _view, html} = live(conn, template_path(template, user))

    assert html =~ template.name
    assert html =~ template.description
  end

  test "adds an item", %{conn: conn} do
    user = insert(:user)

    template =
      insert(
        :repeatable_list_template,
        owner: user,
        name: "Name",
        description: "Description"
      )

    {:ok, view, _html} = live(conn, template_path(template, user))

    view
    |> element("button", "+ Add item")
    |> render_click()

    {:error, {:redirect, %{to: redirect_to}}} =
      view
      |> form("[data-role=new-item-form]", template_item: %{name: "wee"})
      |> render_submit()

    assert redirect_to == ~p"/repeatable-lists/templates/#{template.id}"

    template = RepeatableLists.get_template(user.id, template.id)
    [item] = template.items
    assert item.name == "wee"
  end

  defp template_path(template, user),
    do: ~p"/repeatable-lists/templates/#{template.id}?as=#{user.id}"
end
