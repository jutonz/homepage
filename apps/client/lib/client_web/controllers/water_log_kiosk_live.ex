defmodule ClientWeb.WaterLogKioskLive do
  require Logger
  use Phoenix.LiveView

  alias Client.{
    Util,
    WaterLogs
  }

  def render(assigns) do
    ~H"""
    <div class="m-4 flex flex-col justify-center w-full h-screen">
      <table class="max-h-32">
        <tr>
          <%= for datum <- @data do %>
            <td class="pr-3 h-64 align-bottom">
              <div class="h-full flex flex-col justify-end items-center">
                <span data-role={"usage-for-#{day_name(datum.date)}"}>
                  {datum.amount}
                </span>
                <div {style_for_usage(datum)} class="bg-white w-20"></div>
              </div>
            </td>
          <% end %>
        </tr>

        <tr>
          <%= for datum <- @data do %>
            <td class="pr-3 text-center">{day_name(datum.date)}</td>
          <% end %>
        </tr>
      </table>

      <div class="mt-6 mx-4 text-xl flex justify-between">
        <div>
          <div>
            Total dispensed: {Util.format_number(@total_l)} L
          </div>
          <%= if @filter_life_remaining do %>
            <div>
              Filter life remaining: {Util.format_number(@filter_life_remaining)} L
            </div>
          <% end %>
        </div>

        <div>
          <div>
            Dispensed now: {Util.format_number(@dispensed_now)} ml
          </div>
          <div>
            Weight: {Util.format_number(@weight)} g
          </div>
          <button class="button" phx-click="tare">Tare</button>
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
      schedule_refresh()
    end

    log = WaterLogs.get(log_id)

    assigns = %{
      log: log,
      log_id: log_id,
      data: data(log_id),
      total_l: total_amount_dispensed(log),
      filter_life_remaining: filter_life_remaining(log_id),
      dispensed_now: 0,
      weight: 0
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
    data = socket.assigns[:data]
    today_amount = List.last(data)
    previous_dispensed_today = socket.assigns[:previous_dispensed_today] || today_amount.amount
    new_amount = %{today_amount | amount: previous_dispensed_today + ml}
    data = List.replace_at(data, -1, new_amount)

    max_amount = data |> Enum.map(& &1.amount) |> Enum.max()

    data =
      Enum.map(data, fn amount ->
        percentage =
          if amount.amount == 0 do
            0
          else
            amount.amount / max_amount * 100
          end

        Map.put(amount, :percentage, percentage)
      end)

    assigns = %{
      dispensed_now: ml,
      previous_dispensed_today: previous_dispensed_today,
      data: data
    }

    {:noreply, assign(socket, assigns)}
  end

  def handle_info({:saving, %{"ml" => _ml}}, socket) do
    {:noreply, socket}
  end

  def handle_info(:saved, socket) do
    send(self(), :refresh_usage)
    assigns = %{dispensed_now: 0, previous_dispensed_today: nil}
    {:noreply, assign(socket, assigns)}
  end

  def handle_info(:refresh_usage, socket) do
    log = WaterLogs.get(socket.assigns[:log_id])

    assigns = %{
      log: log,
      data: data(log.id),
      total_l: total_amount_dispensed(log),
      filter_life_remaining: filter_life_remaining(log.id)
    }

    schedule_refresh()
    {:noreply, assign(socket, assigns)}
  end

  def handle_info({:weight, g}, socket) do
    {:noreply, assign(socket, :weight, g)}
  end

  defp data(log_id) do
    beginning_of_day = timezone() |> DateTime.now!() |> Timex.beginning_of_day()

    WaterLogs.get_amount_dispensed_by_day(
      log_id,
      beginning_of_day |> Timex.shift(days: -7),
      beginning_of_day |> Timex.end_of_day()
    )
  end

  defp timezone do
    Application.fetch_env!(:client, :default_timezone)
  end

  defp day_name(datetime) do
    if Timex.day(datetime) == Timex.day(Timex.now(timezone())) do
      "Today"
    else
      Timex.Format.DateTime.Formatters.Strftime.format!(datetime, "%a")
    end
  end

  defp style_for_usage(datum) do
    [style: "height: #{datum.percentage}%"]
  end

  defp filter_life_remaining(log_id) do
    current_filter = WaterLogs.get_current_filter(log_id)

    if current_filter && current_filter.lifespan do
      lifespan_ml = current_filter.lifespan * 1000
      inserted_at = DateTime.from_naive!(current_filter.inserted_at, "Etc/UTC")
      usage_ml = WaterLogs.get_amount_dispensed(log_id, start_at: inserted_at)
      (lifespan_ml - usage_ml) / 1000
    else
      nil
    end
  end

  defp total_amount_dispensed(log) do
    start_at = DateTime.from_naive!(log.inserted_at, "Etc/UTC")
    WaterLogs.get_amount_dispensed(log.id, start_at: start_at) / 1000
  end

  # one hour
  @refresh_after 1000 * 60 * 60
  defp schedule_refresh do
    Process.send_after(self(), :refresh_usage, @refresh_after)
  end
end
