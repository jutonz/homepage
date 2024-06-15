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
          <%= @list.name %>
        </span>
      </ClientWeb.Components.Breadcrumbs.breadcrumbs>

      <div>Created on <%= @list.inserted_at %></div>

      <%= if @list.description do %>
        <div class="mt-3" data-role="desc"><%= @list.description %></div>
      <% end %>

      <hr class="my-3" />

      <%= for item <- @list.items do %>
        <.live_component
          module={ClientWeb.Components.RepeatableLists.Item}
          id={"item-#{item.id}"}
          item={item}
        />
      <% end %>

      <.live_component
        module={ClientWeb.Components.RepeatableLists.AddItemToListButton}
        id="new-item-btn"
        list={@list}
      />

      <%= for section <- @list.sections do %>
        <.live_component
          module={ClientWeb.Components.RepeatableLists.Section}
          id={"section-#{section.id}"}
          section={section}
          list={@list}
        />
      <% end %>
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
