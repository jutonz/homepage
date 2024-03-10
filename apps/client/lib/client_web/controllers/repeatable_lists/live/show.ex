defmodule ClientWeb.RepeatableLists.Live.Show do
  use ClientWeb, :live_view
  alias Client.RepeatableLists

  def render(assigns) do
    ~H"""
    <div class="m-4">
      <ClientWeb.Components.Breadcrumbs.breadcrumbs>
        <:crumb title="Repeatable lists" href={~p"/repeatable-lists/templates"} />
        <:crumb title={@template.name} href={~p"/repeatable-lists/templates/#{@template.id}"} />
        <span data-role="name">
          <%= @list.name %> (<%= @list.inserted_at %>)
        </span>
      </ClientWeb.Components.Breadcrumbs.breadcrumbs>

      <%= if @list.description do %>
        <div><%= @list.description %></div>
      <% end %>

      <hr class="my-3" />
    </div>
    """
  end

  def mount(%{"id" => id}, %{"user_id" => user_id}, socket) do
    list = RepeatableLists.get_list(user_id, id)
    template = list.template
    socket = assign(socket, list: list, template: template)

    {:ok, socket, layout: {ClientWeb.LayoutView, :app}}
  end
end
