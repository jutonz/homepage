defmodule ClientWeb.Storage.ContextItemsLive do
  use ClientWeb, :live_view

  alias Client.{
    Repo,
    Storage
  }

  def mount(_params, assigns, socket) do
    if connected?(socket) do
      context =
        assigns["user_id"]
        |> Storage.get_context(assigns["context_id"])
        |> Repo.preload(items: Storage.ItemQuery.order_by_name(Storage.Item))

      assigns = [
        user_id: assigns["user_id"],
        context: context,
        items: context.items,
        loading: false,
        search: ""
      ]

      {:ok, assign(socket, assigns)}
    else
      {:ok, assign(socket, :loading, true)}
    end
  end

  def render(assigns) do
    if assigns[:loading] do
      render_loading(assigns)
    else
      render_items(assigns)
    end
  end

  defp render_loading(assigns) do
    ~L"""
    <div class="text-lg mb-4">Items</div>
    <div class="m-4">Loading...</div>
    """
  end

  defp render_items(assigns) do
    ~L"""
    <div class="flex mb-4">
      <div class="text-lg mb-1 mr-5">Items</div>
      <form phx-change="search_changed">
        <%= text_input(:search, :query, phx_debounce: 500, placeholder: "Search") %>
      </form>
    </div>
    <table class="mb-4">
      <th>
        <tr>
          <td class="pr-2">ID</td>
          <td class="pr-2">Name</td>
          <td class="p-2">Location</td>
          <td class="p-2">Unpacked</td>
          <td class="p-2">Description</td>
        </tr>
      </th>

      <%= for item <- @items do %>
        <tr class="hover:bg-gray-800 cursor-pointer" phx-click="redirect_to_item" phx-value-item-id="<%= item.id %>">
        <td class="pr-2">
            <%= item.id %>
          </td>
          <td class="pr-2">
            <%= item.name %>
          </td>
          <td class="p-2">
            <%= item.location %>
          </td>
          <td class="p-2">
            <%= ClientWeb.GenericHelpers.existential_checkmark(item.unpacked_at) %>
          </td>
          <td class="p-2">
            <%= item.description %>
          </td>
        </tr>
      <% end %>
    </table>
    """
  end

  def handle_event("search_changed", value, socket) do
    query = value["search"]["query"]

    items =
      Storage.search_items(
        socket.assigns[:user_id],
        socket.assigns[:context].id,
        query
      )

    {:noreply, assign(socket, :items, items)}
  end

  def handle_event("redirect_to_item", %{"item-id" => item_id}, socket) do
    path =
      Routes.storage_context_item_path(
        ClientWeb.Endpoint,
        :edit,
        socket.assigns[:context],
        item_id
      )

    {:noreply, redirect(socket, to: path)}
  end
end
