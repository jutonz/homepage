defmodule ClientWeb.FoodLogsLive.Show do
  use ClientWeb, :live_view
  alias Client.FoodLogs

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

  def mount(params, session, socket) do
    LiveHelpers.allow_ecto_sandbox(socket)
    %{"id" => log_id} = params
    %{"user_id" => user_id} = session

    log = FoodLogs.get(log_id)
    now = now()

    days =
      0..30
      |> Enum.map(&DateTime.add(now, &1 * -1, :day))

    socket =
      assign(socket,
        log: log,
        user_id: user_id,
        days: days,
        form: empty_form()
      )

    {:ok, socket}
  end

  def handle_event("add_entry", %{"entry" => entry_params}, socket) do
    req_params = %{
      "food_log_id" => socket.assigns[:log].id,
      "user_id" => socket.assigns[:user_id],
      "occurred_at" => now()
    }

    entry_params = Map.merge(entry_params, req_params)

    case FoodLogs.create_entry(entry_params) do
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
        Timex.day(day) == Timex.day(entry.occurred_at)
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
