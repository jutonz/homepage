defmodule ClientWeb.WaterLogs.Usage do
  use Phoenix.LiveComponent

  alias Client.{
    Util,
    WaterLogs
  }

  def update(assigns, socket) do
    log = assigns[:log]

    assigns =
      assigns
      |> Map.put(:total_ml, total_amount_dispensed(log))
      |> Map.put(:today_ml, amount_dispensed_today(log))
      |> Map.put(:life_remaining, get_life_remaining(log))

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~L"""
    <div>
      Dispensed today: <%= Util.format_number(@today_ml) %> ml
    </div>
    <div class="mt-3">
      Total dispensed: <%= Util.format_number(@total_ml) %> ml
    </div>

    <%= if @life_remaining do %>
      <div class="mt-3">
        Filter life remaining: <%= @life_remaining %> L
      </div>
    <% end %>
    """
  end

  defp amount_dispensed_today(log) do
    beginning_of_today = now() |> beginning_of_day()
    WaterLogs.get_amount_dispensed(log.id, start_at: beginning_of_today)
  end

  defp total_amount_dispensed(log) do
    start_at = DateTime.from_naive!(log.inserted_at, "Etc/UTC")
    WaterLogs.get_amount_dispensed(log.id, start_at: start_at)
  end

  defp beginning_of_day(datetime) do
    %{datetime | hour: 0, minute: 0, second: 0, microsecond: {0, 0}}
  end

  defp now do
    :client
    |> Application.fetch_env!(:default_timezone)
    |> DateTime.now!()
  end

  defp get_life_remaining(log) do
    current_filter = WaterLogs.get_current_filter(log.id)

    if current_filter && current_filter.lifespan do
      lifespan = current_filter.lifespan
      inserted_at = DateTime.from_naive!(current_filter.inserted_at, "Etc/UTC")
      usage_ml = WaterLogs.get_amount_dispensed(log.id, start_at: inserted_at)
      usage_l = floor(usage_ml / 1000)
      lifespan - usage_l
    else
      nil
    end
  end
end
