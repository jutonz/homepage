defmodule ClientWeb.FoodLogsLive.Show do
  use ClientWeb, :live_view
  alias Client.FoodLogs
  alias Client.FoodLogs.FoodLog

  def render(assigns) do
    ~H"""
    <div class="m-4">
      <ClientWeb.Components.Breadcrumbs.breadcrumbs>
        <:crumb title="Food Logs" href={~p"/food-logs"} />
        <div class="flex flex-row">
          <span data-role="food-log-title">{@log.name}</span>
          <div class="ml-5">
            <.link href={~p"/food-logs/#{@log.id}/edit"} class="button mr-4">Edit</.link>
            {link(
              "Delete",
              to: ~p"/food-logs/#{@log.id}",
              method: :delete,
              data: [confirm: "Are you sure"],
              class: "button"
            )}
          </div>
        </div>
      </ClientWeb.Components.Breadcrumbs.breadcrumbs>

      <%= for day <- @days do %>
        <div>
          <.live_component
            module={ClientWeb.Components.FoodLogs.DayView}
            id={day}
            scope={@scope}
            log_id={@log.id}
            date={day}
          />
        </div>
      <% end %>

      <.simple_form for={@form} phx-submit="add_entry">
        <div class="flex flex-row items-center">
          <.input field={@form[:description]} data-role="entry-desc-input" />
          <button class="button mt-2 ml-4" data-role="entry-submit">
            Add entry
          </button>
        </div>
      </.simple_form>
    </div>
    """
  end

  def mount(%{"id" => log_id}, _session, socket) do
    case FoodLogs.get(socket.assigns.scope, log_id) do
      %FoodLog{} = log -> {:ok, assign(socket, log: log, days: days(), form: empty_form())}
      nil -> not_found(socket)
    end
  end

  def handle_event("add_entry", %{"entry" => entry_params}, socket) do
    entry_params = Map.put(entry_params, "occurred_at", now())

    case FoodLogs.create_entry(socket.assigns.scope, socket.assigns.log.id, entry_params) do
      {:ok, entry} ->
        update_entry_day(entry, socket)
        {:noreply, assign(socket, form: empty_form())}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_info({:entry_deleted, entry}, socket) do
    update_entry_day(entry, socket)
    {:noreply, socket}
  end

  def handle_info({:entry_updated, entry}, socket) do
    update_entry_day(entry, socket)
    {:noreply, socket}
  end

  defp not_found(socket) do
    if connected?(socket) do
      {:ok, redirect(socket, to: ~p"/food-logs")}
    else
      raise Ecto.NoResultsError, queryable: FoodLog
    end
  end

  defp days do
    now = now()
    Enum.map(0..30, &DateTime.add(now, &1 * -1, :day))
  end

  defp empty_form,
    do: %FoodLogs.Entry{} |> FoodLogs.entry_changeset(%{}) |> to_form()

  defp timezone,
    do: Application.get_env(:client, :default_timezone)

  defp now do
    with {:ok, now} <- DateTime.now(timezone()) do
      now
    end
  end

  defp ids_for_entry_day(entry, socket) do
    all_days = socket.assigns[:days]

    matching_day =
      Enum.find(all_days, fn day ->
        Date.day_of_year(day) == Date.day_of_year(entry.occurred_at)
      end)

    if matching_day do
      [matching_day]
    else
      all_days
    end
  end

  defp update_entry_day(entry, socket) do
    Enum.each(ids_for_entry_day(entry, socket), fn id ->
      send_update(self(), ClientWeb.Components.FoodLogs.DayView, id: id)
    end)
  end
end
