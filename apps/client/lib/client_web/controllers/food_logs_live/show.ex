defmodule ClientWeb.FoodLogsLive.Show do
  use ClientWeb, :live_view
  alias Client.FoodLogs

  def render(assigns) do
    ~H"""
    <div class="m-4">
      <ClientWeb.Components.Breadcrumbs.breadcrumbs>
        <:crumb title="Food Logs" href={~p"/food-logs"} />
        <span><%= "hey" %></span>
      </ClientWeb.Components.Breadcrumbs.breadcrumbs>

      <%= for day <- @days do %>
        <div>
          <.live_component
            module={ClientWeb.Components.FoodLogs.DayView}
            id={day}
            log_id={@log_id}
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
    %{"id" => log_id} = params
    %{"user_id" => user_id} = session

    now = now()

    days =
      0..30
      |> Enum.map(&DateTime.add(now, &1 * -1, :day))

    socket =
      assign(socket,
        log_id: log_id,
        user_id: user_id,
        days: days,
        form: empty_form()
      )

    {:ok, socket, layout: {ClientWeb.LayoutView, :app}}
  end

  def handle_event("add_entry", %{"entry" => entry_params}, socket) do
    req_params = %{
      "food_log_id" => socket.assigns[:log_id],
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

  defp today,
    do: DateTime.to_date(now())

  defp id_for_entry_day(entry, socket) do
    Enum.find(socket.assigns[:days], fn day ->
      Timex.day(day) == Timex.day(entry.occurred_at)
    end)
  end

  defp update_entry_day(entry, socket) do
    id = id_for_entry_day(entry, socket)
    send_update(self(), ClientWeb.Components.FoodLogs.DayView, id: id)
  end
end
