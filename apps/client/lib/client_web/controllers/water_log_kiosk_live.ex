defmodule ClientWeb.WaterLogKioskLive do
  require Logger
  use Phoenix.LiveView

  alias Client.{
    Util,
    WaterLogs
  }

  def render(assigns) do
    ~L"""
    <div class="m-4">
      <div class="text-3xl">
        <%= if @ml == 0 do %>
          Waiting for activity
        <% else %>
          Dispensed <%= @ml %> ml
          <%= if @saving do %>
            (Saving...)
          <% end %>
        <% end %>
      </div>


      <div class="mt-5 text-xl">
        Total dispensed: <%= Util.format_number(@total_ml) %> ml
      </div>
    </div>
    """
  end

  def mount(%{"water_log_id" => log_id} = _params, _opts, socket) do
    if connected?(socket) do
      topic = "water_log_internal:#{log_id}"
      Logger.info("liveview subscribed to #{topic}")
      :ok = Phoenix.PubSub.subscribe(Client.PubSub, topic, link: true)
    end

    assigns = %{
      ml: 0,
      saving: false,
      log_id: log_id,
      total_ml: WaterLogs.get_amount_dispensed(log_id)
    }

    {:ok, assign(socket, assigns)}
  end

  def handle_info({:set_ml, %{"ml" => ml}}, socket) do
    {:noreply, assign(socket, :ml, ml)}
  end

  def handle_info({:saving, %{"ml" => ml}}, socket) do
    {:noreply, assign(socket, %{saving: true, ml: ml})}
  end

  def handle_info(:saved, socket) do
    assigns = %{
      saving: false,
      ml: 0,
      total_ml: WaterLogs.get_amount_dispensed(socket.assigns[:log_id])
    }

    {:noreply, assign(socket, assigns)}
  end
end
