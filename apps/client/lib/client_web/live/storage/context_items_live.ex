defmodule ClientWeb.Storage.ContextItemsLive do
  use ClientWeb, :live_view

  alias Client.{
    Repo,
    Storage
  }

  def mount(_params, assigns, socket) do
    LiveHelpers.allow_ecto_sandbox(socket)

    if connected?(socket) do
      context =
        assigns["user_id"]
        |> Storage.get_context(assigns["context_id"])
        |> Repo.preload(items: Storage.ItemQuery.order_by_id_desc(Storage.Item))

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
    ~H"""
    <div class="text-lg mb-4">Items</div>
    <div class="m-4">Loading...</div>
    """
  end

  defp render_items(assigns) do
    ~H"""
    <div class="flex justify-between align-center">
      <div class="text-lg mb-1 mr-5">Items</div>
      <%= link(
        "New item",
        to: Routes.storage_context_item_path(ClientWeb.Endpoint, :new, @context),
        class: "button"
      ) %>
    </div>

    <form class="flex flex-1 mt-5 mb-3" data-role="search-form" phx-change="search_changed">
      <%= text_input(
        :search,
        :query,
        phx_debounce: 500,
        placeholder: "Search",
        class: "rounded-sm flex-1"
      ) %>
    </form>

    <div>
      <%= for item <- @items do %>
        <div class="py-3 border-b hover:bg-gray-800 cursor-pointer" data-item-id={item.id} phx-click="redirect_to_item" phx-value-item-id={item.id}>
          <div class="mb-2">
            <span class="font-bold">
              <%= item.name %>
            </span>
            <%= if item.description do %>
              <span class="font-thin">→</span> <%= item.description %>
            <% end %>
          </div>
          <div class="flex justify-between">
            <div class="flex">
              <div class="">ID</div>
              <div class="pl-1"><%= item.id %></div>
            </div>
            <div class="flex">
              <div><%= item.location %></div>
            </div>
          </div>
        </div>
      <% end %>
    </div>
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
