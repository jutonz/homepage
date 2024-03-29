defmodule ClientWeb.RepeatableLists.Live.ShowTest do
  use ClientWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  alias Client.Repo

  test "renders the name and description", %{conn: conn} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)

    list =
      insert(
        :repeatable_list,
        template: template,
        name: "Name",
        description: "Description"
      )

    {:ok, _view, html} = live(conn, list_path(list, user))

    assert html =~ list.name
    assert html =~ list.description
  end

  test "renders items without a section", %{conn: conn} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)
    list = insert(:repeatable_list, template: template)
    item = insert(:repeatable_list_item, list: list, name: "hello")

    {:ok, _view, html} = live(conn, list_path(list, user))

    assert html =~ item.name
  end

  test "allows adding items directly to the list", %{conn: conn} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)
    list = insert(:repeatable_list, template: template)
    {:ok, view, _html} = live(conn, list_path(list, user))

    view
    |> element("button", "+ Add item")
    |> render_click()

    view
    |> form("[data-role=new-item-form]", item: %{name: "wee"})
    |> render_submit()

    view
    |> assert_redirect(list_path(list))

    list = Repo.preload(list, :items)
    assert [item] = list.items
    assert item.name == "wee"
  end

  test "allows updating items", %{conn: conn} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)
    list = insert(:repeatable_list, template: template)
    item = insert(:repeatable_list_item, list: list, name: "hello")
    {:ok, view, _html} = live(conn, list_path(list, user))

    view
    |> form("[data-role=item-form]", name: "wee")
    |> render_submit()
    |> assert_contains_selector("input[name=name][value=wee]")

    assert Repo.reload(item).name == "wee"
  end

  test "renders sections", %{conn: conn} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)
    list = insert(:repeatable_list, template: template)
    section1 = insert(:repeatable_list_section, list: list, name: "section1!")
    section2 = insert(:repeatable_list_section, list: list, name: "section2")

    {:ok, _view, html} = live(conn, list_path(list, user))

    assert html =~ section1.name
    assert html =~ section2.name
  end

  test "allows adding items to secitons", %{conn: conn} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)
    list = insert(:repeatable_list, template: template)
    section = insert(:repeatable_list_section, list: list, name: "section!")
    {:ok, view, _html} = live(conn, list_path(list, user))

    view
    |> element("[data-section-id='#{section.id}'] button", "+ Add item")
    |> render_click()

    view
    |> form("[data-role=new-item-form]", item: %{name: "item!"})
    |> render_submit()

    view
    |> assert_redirected(list_path(list))

    section = Repo.preload(section, :items)
    assert [item] = section.items
    assert item.name == "item!"
  end

  test "allows completing items", %{conn: conn} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)
    list = insert(:repeatable_list, template: template)
    item = insert(:repeatable_list_item, list: list)
    {:ok, view, _html} = live(conn, list_path(list, user))

    view
    |> element("[data-item-id='#{item.id}'] [role=button]")
    |> render_click()

    assert view
           |> element("[data-item-id='#{item.id}'] input[type=checkbox][checked]")
           |> has_element?()

    item = Repo.reload!(item)
    assert item.completed_at
  end

  test "allows un-completing items", %{conn: conn} do
    user = insert(:user)
    template = insert(:repeatable_list_template, owner: user)
    list = insert(:repeatable_list, template: template)
    item = insert(:repeatable_list_item, list: list, completed_at: DateTime.utc_now())
    {:ok, view, _html} = live(conn, list_path(list, user))

    view
    |> element("[data-item-id='#{item.id}'] [role=button]")
    |> render_click()

    assert view
           |> element("[data-item-id='#{item.id}'] input[type=checkbox]")
           |> has_element?()

    item = Repo.reload!(item)
    refute item.completed_at
  end

  defp list_path(list), do: ~p"/repeatable-lists/#{list.id}"
  defp list_path(list, user), do: ~p"/repeatable-lists/#{list.id}?as=#{user.id}"
end
