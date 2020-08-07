defmodule ClientWeb.WaterLogKioskLive do
  require Logger
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="m-4">
      Hi <%= @ml %> ml
    </div>
    """
  end

  def mount(%{"water_log_id" => log_id} = _params, _opts, socket) do
    if connected?(socket) do
      topic = "water_log_internal:#{log_id}"
      Logger.info("liveview subscribed to #{topic}")
      :ok = Phoenix.PubSub.subscribe(Client.PubSub, topic, link: true)
    end

    assigns = %{ml: 0}
    {:ok, assign(socket, assigns)}
  end

  def handle_info({:set_ml, %{"ml" => ml}}, socket) do
    {:noreply, assign(socket, :ml, ml)}
  end
end
