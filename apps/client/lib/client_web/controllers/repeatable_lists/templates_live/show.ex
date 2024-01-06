defmodule ClientWeb.RepeatableLists.TemplatesLive.Show do
  use ClientWeb, :live_view
  alias Client.RepeatableLists

  def render(assigns) do
    ~H"""
    <div class="m-4">
      <ClientWeb.Components.Breadcrumbs.breadcrumbs>
        <:crumb title="Repeatable lists" href={~p"/repeatable-lists"} />
        <span data-role="name"><%= @template.name %></span>
      </ClientWeb.Components.Breadcrumbs.breadcrumbs>

      <%= if @template.description do %>
        <div><%= @template.description %></div>
      <% end %>

      <button
        type="button"
        phx-click={show_modal("delete-confirm")}
        class="button button--danger mt-10"
      >
        Delete template
      </button>

      <.modal id="delete-confirm">
        <h1 class="text-2xl mb-4">Delete list template?</h1>
        <p class="mb-4">This will also delete any lists created from this template.</p>
        <p class="mb-4">Are you sure?</p>

        <button phx-click="delete" class="button button--danger mt-10">
          Delete template
        </button>
      </.modal>
    </div>
    """
  end

  def mount(%{"id" => id}, %{"user_id" => user_id}, socket) do
    template = RepeatableLists.get_template(user_id, id)
    {:ok, assign(socket, template: template), layout: {ClientWeb.LayoutView, :app}}
  end

  def handle_event("delete", _params, socket) do
    template = socket.assigns[:template]

    socket =
      case RepeatableLists.delete_template(template) do
        {:ok, _template} ->
          socket
          |> put_flash(:info, "Deleted template")
          |> redirect(to: ~p"/repeatable-lists")

        {:error, _changeset} ->
          socket
          |> put_flash(:error, "Failed to delete template")
      end

    {:noreply, socket}
  end
end
