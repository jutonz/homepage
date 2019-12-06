defmodule ClientWeb.FoodLog.EntriesView do
  use Phoenix.LiveView
  alias Client.FoodLogs
  alias Client.FoodLogs.Entry

  def render(assigns) do
    Phoenix.View.render(ClientWeb.FoodLogView, "entries.html", assigns)
  end

  def mount(session, socket) do
    entry_cs = FoodLogs.entry_changeset(%Entry{}, %{})

    socket =
      socket
      |> assign(:log, session[:log])
      |> assign(:current_user_id, session[:current_user_id])
      |> assign(:entry_changeset, entry_cs)
      |> assign(:entries, FoodLogs.list_entries_by_day(session[:log].id))
      |> assign(:editing, empty_entry())

    {:ok, socket}
  end

  defp list_entries(socket),
    do: FoodLogs.list_entries_by_day(socket.assigns[:log].id)
end
