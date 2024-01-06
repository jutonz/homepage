defmodule ClientWeb.Components.Breadcrumbs do
  use ClientWeb, :html

  slot :crumb, default: [] do
    attr :href, :string, required: true
    attr :title, :string, required: true
  end

  slot :inner_block, required: true

  def breadcrumbs(assigns) do
    ~H"""
    <div class="flex align-center text-xl mb-4">
      <.back_crumb title="Home" href={~p"/"} />

      <%= for crumb <- @crumb do %>
        <.back_crumb title={crumb.title} href={crumb.href} />
      <% end %>

      <div>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  attr :href, :string, required: true
  attr :title, :string, required: true

  defp back_crumb(assigns) do
    ~H"""
    <div class="mr-2 text-gray-400">
      <.link href={@href}><%= @title %></.link>
    </div>
    <span class="mr-2">></span>
    """
  end
end
