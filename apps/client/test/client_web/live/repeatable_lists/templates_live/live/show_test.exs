defmodule ClientWeb.RepeatableLists.TemplatesLive.Live.ShowTest do
  use ClientWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

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

  defp list_path(template, user), do: ~p"/repeatable-lists/#{template.id}?as=#{user.id}"
end
