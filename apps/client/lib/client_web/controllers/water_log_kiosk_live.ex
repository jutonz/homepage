defmodule ClientWeb.WaterLogKioskLive do
  require Logger
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <h3 class="m-4">
      <%= if @ml == 0 do %>
        Waiting for activity
      <% else %>
        Dispensed <%= @ml %> ml
      <% end %>
    </h3>

    <%= if @saving do %>
      <h3 class="mt-3">
        Saving...
      </h3>
    <% end %>
    """
  end

  def mount(%{"water_log_id" => log_id} = _params, _opts, socket) do
    if connected?(socket) do
      topic = "water_log_internal:#{log_id}"
      Logger.info("liveview subscribed to #{topic}")
      :ok = Phoenix.PubSub.subscribe(Client.PubSub, topic, link: true)
    end

    assigns = %{ml: 0, saving: false}
    {:ok, assign(socket, assigns)}
  end

  def handle_info({:set_ml, %{"ml" => ml}}, socket) do
    {:noreply, assign(socket, :ml, ml)}
  end

  def handle_info({:saving, %{"ml" => ml}}, socket) do
    {:noreply, assign(socket, %{saving: true, ml: ml})}
  end

  def handle_info(:saved, socket) do
    {:noreply, assign(socket, %{saving: false, ml: 0})}
  end
end
