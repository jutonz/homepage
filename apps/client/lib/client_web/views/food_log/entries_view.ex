defmodule ClientWeb.FoodLog.EntriesView do
  use ClientWeb, :live_view
  alias Client.FoodLogs
  alias Client.FoodLogs.Entry

  def render(assigns) do
    Phoenix.View.render(ClientWeb.FoodLogView, "entries.html", assigns)
  end

  def mount(_params, session, socket) do
    LiveHelpers.allow_ecto_sandbox(socket)
    entry_cs = FoodLogs.entry_changeset(%Entry{}, %{})

    assigns = [
      log: session["log"],
      current_user_id: session["current_user_id"],
      form: to_form(entry_cs),
      entries: list_entries(session),
      today: today()
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("add_entry", %{"entry" => entry_params}, socket) do
    req_params = %{
      "food_log_id" => socket.assigns[:log].id,
      "user_id" => socket.assigns[:current_user_id],
      "occurred_at" => now()
    }

    entry_params = Map.merge(entry_params, req_params)

    case FoodLogs.create_entry(entry_params) do
      {:ok, _entry} ->
        assigns = [
          entries: list_entries(socket),
          form: %Entry{} |> FoodLogs.entry_changeset(%{}) |> to_form()
        ]

        {:noreply, assign(socket, assigns)}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_info({:entry_deleted, _entry}, socket),
    do: {:noreply, assign(socket, :entries, list_entries(socket))}

  def handle_info({:entry_updated, _entry}, socket),
    do: {:noreply, assign(socket, :entries, list_entries(socket))}

  defp list_entries(%Phoenix.LiveView.Socket{} = socket),
    do: list_entries(socket.assigns[:log].id)

  defp list_entries(session) when is_map(session),
    do: list_entries(session["log"].id)

  defp list_entries(log_id) when is_binary(log_id),
    do: log_id |> FoodLogs.list_entries_by_day() |> maybe_add_today()

  defp timezone,
    do: Application.get_env(:client, :default_timezone)

  defp maybe_add_today(entries),
    do: Map.put_new(entries, today(), [])

  defp now do
    with {:ok, now} <- DateTime.now(timezone()) do
      now
    end
  end

  defp today,
    do: DateTime.to_date(now())
end
