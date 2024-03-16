defmodule ClientWeb.RepeatableLists.TemplatesLive.Live.ShowTest do
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

  defp list_path(list, user), do: ~p"/repeatable-lists/#{list.id}?as=#{user.id}"
end
