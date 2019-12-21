defmodule ClientWeb.FoodLog.EntryView do
  use Phoenix.LiveComponent
  alias Client.FoodLogs

  def mount(socket) do
    assigns = [
      changeset: nil
    ]

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    Phoenix.View.render(ClientWeb.FoodLogView, "entry.html", assigns)
  end

  def preload(list_of_assigns) do
    entries =
      list_of_assigns
      |> Enum.map(&Map.get(&1, :id))
      |> FoodLogs.get_entries()
      |> Enum.map(&{&1.id, &1})
      |> Map.new()

    Enum.map(list_of_assigns, fn assigns ->
      Map.put(assigns, :entry, entries[assigns.id])
    end)
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def handle_event("edit_entry", _value, socket) do
    changeset = FoodLogs.entry_changeset(socket.assigns[:entry])
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("cancel_edit_entry", _value, socket),
    do: {:noreply, assign(socket, :changeset, nil)}

  def handle_event("update_entry", %{"entry" => entry_params}, socket) do
    entry = socket.assigns[:entry]

    req_params = %{
      "food_log_id" => entry.food_log_id,
      "user_id" => entry.user_id
    }

    entry_params = Map.merge(entry_params, req_params)

    case FoodLogs.update_entry(entry, entry_params) do
      {:ok, entry} ->
        assigns = [changeset: nil, entry: entry]
        {:noreply, assign(socket, assigns)}

      {:error, changeset} ->
        raise changeset
        {:noreply, assign(socket, :changeset, changeset)}
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
end
