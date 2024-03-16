defmodule ClientWeb.Components.RepeatableLists.AddItemToListButton do
  use ClientWeb, :live_component
  alias Client.RepeatableLists

  def render(assigns) do
    ~H"""
    <div>
      <%= if assigns[:new_item_changeset] do %>
        <.simple_form
          for={@new_item_changeset}
          phx-submit="save_new_item"
          phx-target={@myself}
          data-role="new-item-form"
        >
          <.input field={@new_item_changeset[:name]} label="Name" autofocus />
        </.simple_form>
      <% else %>
        <button phx-click="add_item" phx-target={@myself} class="button button--inline my-2 ml-2">
          + Add item
        </button>
      <% end %>
    </div>
    """
  end

  def handle_event("add_item", _params, socket) do
    list = socket.assigns[:list]

    new_item =
      list
      |> Ecto.build_assoc(:items)
      |> RepeatableLists.item_changeset()

    {:noreply, assign(socket, new_item_changeset: to_form(new_item))}
  end

  def handle_event("save_new_item", %{"item" => params}, socket) do
    list = socket.assigns[:list]
    section = socket.assigns[:section]

    params =
      if section do
        Map.put(params, "section_id", section.id)
      else
        params
      end

    socket =
      case RepeatableLists.create_item(list.id, params) do
        {:ok, _item} -> redirect(socket, to: ~p"/repeatable-lists/#{list.id}")
        {:error, changeset} -> assign(socket, new_item_changeset: to_form(changeset))
      end

    {:noreply, socket}
  end
end
