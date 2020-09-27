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
end
