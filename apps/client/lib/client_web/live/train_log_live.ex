defmodule ClientWeb.TrainLogLive do
  use ClientWeb, :live_view
  alias Client.Trains
  alias ClientWeb.Router.Helpers, as: Routes

  def render(assigns) do
    if assigns[:loading] do
      render_loading(assigns)
    else
      render_log(assigns)
    end
  end

  defp render_loading(assigns) do
    ~H"""
    <div class="m-4">Loading...</div>
    """
  end

  defp render_log(assigns) do
    ~H"""
    <div class="m-4">
      <div class="text-xl">
        <%= @log.location %>
      </div>

      <div class="mt-3">
        <%= if !Enum.any?(@sightings) do %>
          There haven't been any sightings yet. Get out there!
        <% end %>
      </div>

      <div class="mt-3">
        <%= live_component(
          ClientWeb.TrainLogs.AddSightingButton,
          id: :add_sighting_button,
          user_id: @user_id,
          log_id: @log.id
        ) %>
      </div>

      <table>
        <thead>
          <tr>
            <th class="p-2 pl-0">Date</th>
            <th class="p-2">Time</th>
            <th class="p-2">Direction</th>
            <th class="p-2"># Cars</th>
            <th class="p-2">Engines</th>
          </tr>
        </thead>
        <tbody>
          <%= for sighting <- @sightings do %>
            <tr data-role="train-sighting-row">
              <td class="p-2 pl-0"><%= format_date(sighting) %></td>
              <td class="p-2"><%= format_time(sighting) %></td>
              <td class="p-2"><%= sighting.direction %></td>
              <td class="p-2"><%= sighting.cars %></td>
              <td class="p-2"><%= format_engines(sighting) %></td>
            </tr>
          <% end %>
        </tbody>
        <tr>
          <td></td>
        </tr>
      </table>
    </div>
    """
  end

  def mount(_params, session, socket) do
    LiveHelpers.allow_ecto_sandbox(socket)

    if connected?(socket) do
      assigns = [
        loading: false,
        log: Trains.get_log(session["user_id"], session["id"]),
        sightings: Trains.list_sightings(session["id"]),
        user_id: session["user_id"]
      ]

      socket =
        if assigns[:log] do
          socket
        else
          redirect(socket, to: Routes.train_log_path(socket, :index))
        end

      {:ok, assign(socket, assigns)}
    else
      {:ok, assign(socket, :loading, true)}
    end
  end

  def handle_info(:reload_sightings, socket) do
    log = socket.assigns[:log]
    sightings = Trains.list_sightings(log.id)
    {:noreply, assign(socket, sightings: sightings)}
  end

  defp format_engines(sighting) do
    sighting.engine_sightings
    |> Enum.map(& &1.engine.number)
    |> Enum.join(", ")
  end

  defp format_date(sighting) do
    Calendar.strftime(sighting.sighted_at, "%d %b")
  end

  defp format_time(sighting) do
    Calendar.strftime(sighting.sighted_at, "%H:%M")
  end
end
