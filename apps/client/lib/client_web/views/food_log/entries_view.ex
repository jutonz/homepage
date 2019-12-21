defmodule ClientWeb.FoodLog.EntriesView do
  use Phoenix.LiveView
  alias Client.FoodLogs
  alias Client.FoodLogs.Entry

  def render(assigns) do
    Phoenix.View.render(ClientWeb.FoodLogView, "entries.html", assigns)
  end

  def mount(session, socket) do
    entry_cs = FoodLogs.entry_changeset(%Entry{}, %{})

    assigns = [
      log: session[:log],
      current_user_id: session[:current_user_id],
      entry_changeset: entry_cs,
      entries: FoodLogs.list_entries_by_day(session[:log].id)
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("add_entry", %{"entry" => entry_params}, socket) do
    {:ok, now} = DateTime.now(timezone())

    req_params = %{
      "food_log_id" => socket.assigns[:log].id,
      "user_id" => socket.assigns[:current_user_id],
      "occurred_at" => now
    }

    entry_params = Map.merge(entry_params, req_params)

    case FoodLogs.create_entry(entry_params) do
      {:ok, _entry} ->
        entry_cs = FoodLogs.entry_changeset(%Entry{}, %{})

        socket =
          socket
          |> assign(:entries, list_entries(socket))
          |> assign(:entry_changeset, entry_cs)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :entry_changeset, changeset)}
    end
  end

  defp list_entries(socket),
    do: FoodLogs.list_entries_by_day(socket.assigns[:log].id)

  defp timezone,
    do: Application.get_env(:client, :default_timezone)
end
