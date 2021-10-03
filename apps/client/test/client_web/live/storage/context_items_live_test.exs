defmodule ClientWeb.Live.Storage.ContextItemsLiveTest do
  use ClientWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  @component ClientWeb.Storage.ContextItemsLive

  test "it renders items in a context", %{conn: conn} do
    user = insert(:user)
    context = insert(:storage_context, creator: user)
    item = insert(:storage_item, context: context)
    session = %{"context_id" => context.id, "user_id" => user.id}

    {:ok, _view, html} = live_isolated(conn, @component, session: session)

    item_row =
      html
      |> Floki.parse_document!()
      |> Floki.find("[data-item-id='#{item.id}']")
      |> Floki.text()

    assert item_row =~ item.name
    assert item_row =~ item.location
  end

  test "when an item is clicked, redirects to its edit page", %{conn: conn} do
    user = insert(:user)
    context = insert(:storage_context, creator: user)
    item = insert(:storage_item, context: context)
    session = %{"context_id" => context.id, "user_id" => user.id}

    {:ok, view, _html} = live_isolated(conn, @component, session: session)

    edit_path = Routes.storage_context_item_path(conn, :edit, context, item)

    {:error, {:redirect, %{to: ^edit_path}}} =
      view
      |> element("[data-item-id='#{item.id}']")
      |> render_click()
  end

  test "allows searching for an item", %{conn: conn} do
    user = insert(:user)
    context = insert(:storage_context, creator: user)
    item1 = insert(:storage_item, name: "item 1", context: context)
    item2 = insert(:storage_item, name: "item 2", context: context)
    session = %{"context_id" => context.id, "user_id" => user.id}

    {:ok, view, _html} = live_isolated(conn, @component, session: session)

    doc =
      view
      |> element("[data-role=search-form]")
      |> render_change(%{"search" => %{"query" => "item 1"}})
      |> Floki.parse_document!()

    assert has_item?(doc, item1)
    refute has_item?(doc, item2)
  end

  defp has_item?(doc, item) do
    Floki.find(doc, "[data-item-id='#{item.id}']") != []
  end
end
