defmodule ClientWeb.Components.FoodLogs.DayView do
  use ClientWeb, :live_component
  alias Client.DateTimeHelpers
  alias Client.FoodLogs

  def render(assigns) do
    if Enum.empty?(assigns[:entries]) do
      ~H"<div />"
    else
      ~H"""
      <div>
        <div class="mt-4">
          {Calendar.strftime(@date, "%-d %b %Y")}
        </div>
        <div>
          <%= for entry <- @entries do %>
            <.live_component module={ClientWeb.FoodLog.EntryView} id={entry.id} scope={@scope} />
          <% end %>
        </div>
      </div>
      """
    end
  end

  def update_many(assigns_sockets) do
    {assigns, socket} = hd(assigns_sockets)
    log_id = assigns[:log_id] || socket.assigns[:log_id]
    scope = assigns[:scope] || socket.assigns[:scope]

    dates =
      assigns_sockets
      |> Enum.map(fn {assigns, socket} -> assigns[:date] || socket.assigns[:date] end)
      |> Enum.sort(DateTime)

    entries =
      FoodLogs.list_entries_occurred_between(
        scope,
        log_id,
        DateTimeHelpers.beginning_of_day(hd(dates)),
        DateTimeHelpers.end_of_day(List.last(dates))
      )

    Enum.map(assigns_sockets, fn {assigns, socket} ->
      date = assigns[:date] || socket.assigns[:date]
      day = DateTime.to_date(date)

      day_entries =
        Enum.filter(entries, fn entry ->
          DateTimeHelpers.to_date(entry.occurred_at, date.time_zone) == day
        end)

      socket
      |> assign(assigns)
      |> assign(scope: scope, entries: day_entries)
    end)
  end

  def mount(socket) do
    {:ok, socket}
  end
end
