defmodule ClientWeb.WaterLogKioskLive do
  require Logger
  use Phoenix.LiveView
  alias Client.WaterLogs
  alias ClientWeb.WaterLogs.Usage

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
        <%= live_component(@socket, Usage, id: :usage, log: @log) %>
      </div>

      <div class="mt-5 text-xl">
        Current weight: <%= @current_weight %> g
      </div>

      <div class="mt-3">
        <button class="button" phx-click="tare">Tare</button>
      </div>

    </div>
    """
  end

  def mount(%{"water_log_id" => log_id} = _params, _opts, socket) do
    if connected?(socket) do
      topic = "water_log_internal:#{log_id}"
      Logger.info("liveview subscribed to #{topic}")
      :ok = Phoenix.PubSub.subscribe(Client.PubSub, topic, link: true)
      schedule_refresh()
    end

    log = WaterLogs.get(log_id)

    assigns = %{
      ml: 0,
      saving: false,
      log_id: log_id,
      log: log,
      current_weight: 0
    }

    {:ok, assign(socket, assigns)}
  end

  def handle_event("tare", _value, socket) do
    Logger.info("clicked tare button water_log:#{socket.assigns[:log_id]}")

    ClientWeb.Endpoint.broadcast!(
      "water_log:#{socket.assigns[:log_id]}",
      "tare",
      %{}
    )

    {:noreply, socket}
  end

  def handle_info({:set_ml, %{"ml" => ml}}, socket) do
    {:noreply, assign(socket, :ml, ml)}
  end

  def handle_info({:saving, %{"ml" => ml}}, socket) do
    {:noreply, assign(socket, %{saving: true, ml: ml})}
  end

  def handle_info(:saved, socket) do
    send_update(Usage, id: :usage, log: socket.assigns[:log])

    assigns = %{saving: false, ml: 0}
    {:noreply, assign(socket, assigns)}
  end

  def handle_info({:weight, g}, socket) do
    {:noreply, assign(socket, :current_weight, g)}
  end

  def handle_info(:refresh_usage, socket) do
    send_update(Usage, id: :usage, log: socket.assigns[:log])
    Logger.info("refresh usage")
    schedule_refresh()
    {:noreply, socket}
  end

  # one hour
  @refresh_after 1000 * 60 * 60
  defp schedule_refresh do
    Process.send_after(self(), :refresh_usage, @refresh_after)
  end
end
