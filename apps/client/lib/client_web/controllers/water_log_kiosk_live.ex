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
        <div>
          Dispensed today: <%= Util.format_number(@today_ml) %> ml
        </div>
        <div class="mt-3">
          Total dispensed: <%= Util.format_number(@total_ml) %> ml
        </div>
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

    log = WaterLogs.get(log_id)

    assigns = %{
      ml: 0,
      saving: false,
      log_id: log_id,
      log: log,
      today_ml: amount_dispensed_today(log),
      total_ml: total_amount_dispensed(log)
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
      total_ml: total_amount_dispensed(socket.assigns[:log]),
      today_ml: amount_dispensed_today(socket.assigns[:log])
    }

    {:noreply, assign(socket, assigns)}
  end

  defp amount_dispensed_today(log) do
    beginning_of_today = now() |> beginning_of_day()
    WaterLogs.get_amount_dispensed(log.id, start_at: beginning_of_today)
  end

  def total_amount_dispensed(log) do
    start_at = DateTime.from_naive!(log.inserted_at, "Etc/UTC")
    WaterLogs.get_amount_dispensed(log.id, start_at: start_at)
  end

  defp now do
    :client
    |> Application.fetch_env!(:default_timezone)
    |> DateTime.now!()
  end

  defp beginning_of_day(datetime) do
    %{datetime | hour: 0, minute: 0, second: 0, microsecond: {0, 0}}
  end
end
