defmodule ClientWeb.FoodLog.EntryView do
  use Phoenix.LiveComponent
  alias Client.FoodLogs
  alias Client.FoodLogs.Entry

  def render(assigns) do
    Phoenix.View.render(ClientWeb.FoodLogView, "entry.html", assigns)
  end

  def mount(socket) do
    IO.inspect(socket)
    raise socket.assigns
    #entry = assigns[:entry]
    #assigns = %{
      #entry: entry,
      #changeset: FoodLogs.entry_changeset(entry)
    #}
    #
    assigns = %{}

    #raise assigns
    #IO.inspect(assigns)

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

  def handle_event("edit_entry", %{"id" => id}, socket) do
    cs = id |> FoodLogs.get_entry() |> FoodLogs.entry_changeset()

    socket =
      socket
      |> assign(:editing_id, id)
      |> assign(:editing_changeset, cs)

    {:noreply, socket}
  end

  def handle_event("cancel_edit_entry", _value, socket),
    do: {:noreply, assign(socket, :editing_id, nil)}

  def handle_event("update_entry", %{"entry" => entry_params}, socket) do
    req_params = %{
      "food_log_id" => socket.assigns[:log].id,
      "user_id" => socket.assigns[:current_user_id]
    }

    entry_params = Map.merge(entry_params, req_params)
    entry = FoodLogs.get_entry(socket.assigns[:editing_id])

    case FoodLogs.update_entry(entry, entry_params) do
      {:ok, _entry} ->
        socket =
          socket
          |> assign(:entries, list_entries(socket))
          |> assign(:editing_id, nil)
          |> assign(:editing_changeset, nil)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :entry_changeset, changeset)}
    end
  end

  def handle_event("delete_entry", _value, socket) do
    {:ok, _entry} = FoodLogs.delete_entry(socket.assigns[:editing_id])

    socket =
      socket
      |> assign(:entries, list_entries(socket))
      |> assign(:editing_id, nil)
      |> assign(:editing_changeset, nil)

    {:noreply, socket}
  end

  defp list_entries(socket),
    do: FoodLogs.list_entries_by_day(socket.assigns[:log].id)

  defp timezone,
    do: Application.get_env(:client, :default_timezone)
end
