defmodule ClientWeb.Components.RepeatableLists.TemplateSection do
  use ClientWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <h2 class="text-xl">
        Section: <%= @section.name %>
      </h2>
    </div>
    """
  end
end
