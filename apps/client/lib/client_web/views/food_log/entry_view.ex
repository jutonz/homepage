defmodule ClientWeb.FoodLog.EntryView do
  use Phoenix.LiveView
  alias Client.FoodLogs
  alias Client.FoodLogs.Entry

  def render(assigns) do
    Phoenix.View.render(ClientWeb.FoodLogView, "entries.html", assigns)
  end

  def mount(session, socket) do
    socket =
      socket
      |> assign(:log, session[:log])
      |> assign(:current_user_id, session[:current_user_id])
      |> assign(:show_add, false)
      |> assign(:entries, FoodLogs.list_entries_by_day(session[:log].id))

    {:ok, socket}
  end

  def handle_event("show_add_entry", _value, socket) do
    entry_cs = FoodLogs.entry_changeset(%Entry{}, %{})

    socket =
      socket
      |> assign(:show_add, true)
      |> assign(:entry_changeset, entry_cs)

    {:noreply, socket}
  end

  def handle_event("add_entry", %{"entry" => entry_params}, socket) do
    req_params = %{
      "food_log_id" => socket.assigns[:log].id,
      "user_id" => socket.assigns[:current_user_id],
      "occurred_at" => DateTime.utc_now()
    }

    entry_params = Map.merge(entry_params, req_params)

    case FoodLogs.create_entry(entry_params) do
      {:ok, _entry} ->
        socket =
          socket
          |> assign(:entries, list_entries(socket))
          |> assign(:show_add, false)

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(:entry_changeset, changeset)

        {:noreply, socket}
    end
  end

  defp list_entries(socket),
    do: FoodLogs.list_entries_by_day(socket.assigns[:log].id)
end
