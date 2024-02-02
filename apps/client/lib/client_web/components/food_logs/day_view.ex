defmodule ClientWeb.Components.FoodLogs.DayView do
  use ClientWeb, :live_component
  alias Client.FoodLogs

  def render(assigns) do
    if Enum.empty?(assigns[:entries]) do
      ~H"<div />"
    else
      ~H"""
      <div>
        <div class="mt-4">
          <%= Timex.format!(@date, "{D} {Mshort} {YYYY}") %>
        </div>
        <div>
          <%= for entry <- @entries do %>
            <.live_component module={ClientWeb.FoodLog.EntryView} id={entry.id} />
          <% end %>
        </div>
      </div>
      """
    end
  end

  def update_many(assigns_sockets) do
    {assigns, socket} = hd(assigns_sockets)
    log_id = assigns[:log_id] || socket.assigns[:log_id]

    dates =
      assigns_sockets
      |> Enum.map(fn {assigns, _socket} -> assigns[:date] end)
      |> Enum.sort(DateTime)

    today = DateTime.utc_now()
    first_date = hd(dates) || today
    last_date = List.last(dates) || today

    entries =
      FoodLogs.list_entries_between_dates(
        log_id,
        Timex.beginning_of_day(first_date),
        Timex.end_of_day(last_date)
      )

    Enum.map(assigns_sockets, fn {assigns, socket} ->
      day = Timex.day(assigns[:date] || socket.assigns[:date])

      day_entries =
        Enum.filter(entries, fn entry ->
          Timex.day(entry.occurred_at) == day
        end)

      socket
      |> assign(assigns)
      |> assign(entries: day_entries)
    end)
  end

  def mount(socket) do
    {:ok, socket}
  end
end
