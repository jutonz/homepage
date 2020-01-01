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

    entry_params =
      entry_params
      |> Map.merge(req_params)
      |> combine_date_and_time()

    case FoodLogs.update_entry(entry, entry_params) do
      {:ok, entry} ->
        send(self(), {:entry_updated, entry})
        assigns = [changeset: nil, entry: entry]
        {:noreply, assign(socket, assigns)}

      {:error, changeset} ->
        raise changeset
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("delete_entry", _value, socket) do
    {:ok, entry} = FoodLogs.delete_entry(socket.assigns[:entry].id)
    send(self(), {:entry_deleted, entry})
    {:noreply, assign(socket, :changeset, nil)}
  end

  defp combine_date_and_time(entry_params) do
    date = Ecto.Date.cast!(entry_params["occurred_at_date"])
    time = Ecto.Time.cast!(entry_params["occurred_at_time"])

    occurred_at =
      date
      |> Ecto.DateTime.from_date_and_time(time)
      |> Ecto.DateTime.to_iso8601()

    entry_params
    |> Map.drop(~w[occurred_at_date occurred_at_time])
    |> Map.put("occurred_at", occurred_at)
  end
end
