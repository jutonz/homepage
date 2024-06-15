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

  test "renders links to associated lists", %{conn: conn} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)
    list = insert(:repeatable_list, template: template)
    {:ok, view, _html} = live(conn, template_path(template, user))

    view
    |> element("a", list.name)
    |> render_click()

    view
    |> assert_redirected(~p"/repeatable-lists/#{list.id}")
  end

  test "adds an item", %{conn: conn} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)

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

  test "adds an item to a section", %{conn: conn} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)
    section = insert(:repeatable_list_template_section, template: template, name: "section!")
    {:ok, view, _html} = live(conn, template_path(template, user))

    view
    |> element("[data-section-id='#{section.id}'] button", "+ Add item")
    |> render_click()

    view
    |> form("[data-role=new-item-form]", template_item: %{name: "item"})
    |> render_submit()

    view
    |> assert_redirected(~p"/repeatable-lists/templates/#{template.id}")

    template = RepeatableLists.get_template(user.id, template.id)
    [section] = template.sections
    [item] = section.items
    assert item.name == "item"
    assert item.section_id == section.id
  end

  test "copies a list", %{conn: conn} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)
    {:ok, view, _html} = live(conn, template_path(template, user))

    {:error, {:redirect, %{to: to}}} =
      view
      |> element("a", "Clone")
      |> render_click()

    assert to == "/repeatable-lists/templates/#{template.id}/clones/new"
  end

  defp template_path(template, user),
    do: ~p"/repeatable-lists/templates/#{template.id}?as=#{user.id}"
end
