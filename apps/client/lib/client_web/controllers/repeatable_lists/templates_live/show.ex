defmodule ClientWeb.RepeatableLists.TemplatesLive.Show do
  use ClientWeb, :live_view
  alias Client.RepeatableLists

  def render(assigns) do
    ~H"""
    <div class="m-4">
      <div class="flex align-center text-xl mb-4">
        <div class="mr-2 text-gray-400">
          <.link href={~p"/repeatable-lists"}>
            Repetable lists
          </.link>
        </div>
        >
        <div class="ml-2">
          <%= @template.name %>
        </div>
      </div>

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

      <.modal id="delete-confirm" show={false}>
        hello
        <.link
          href={~p"/repeatable-lists/templates/#{@template.id}"}
          class="button button--danger mt-10"
          method="delete"
        >
          Delete template
        </.link>
      </.modal>
    </div>
    """
  end

  def mount(%{"id" => id}, %{"user_id" => user_id}, socket) do
    template = RepeatableLists.get_template(user_id, id)
    {:ok, assign(socket, template: template), layout: {ClientWeb.LayoutView, :app}}
  end

  # def handle_event("show_modal", _params, socket) do
  #   {:noreply, assign(socket, show_delete_confirm: true)}
  # end
end
