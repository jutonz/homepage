defmodule ClientWeb.Components.RepeatableLists.Section do
  use ClientWeb, :live_component

  def render(assigns) do
    ~H"""
    <div data-section-id={@section.id}>
      <h2 class="text-xl">
        Section: <%= @section.name %>
      </h2>

      <%= for item <- @section.items do %>
        <.live_component
          module={ClientWeb.Components.RepeatableLists.Item}
          id={"item-#{item.id}"}
          item={item}
        />
      <% end %>

      <div class="ml-3">
        <.live_component
          module={ClientWeb.Components.RepeatableLists.AddItemToListButton}
          id={"new-item-btn-section-#{@section.id}"}
          list={@list}
          section={@section}
        />
      </div>
    </div>
    """
  end
end
