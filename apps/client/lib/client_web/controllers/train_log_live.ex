defmodule ClientWeb.TrainLogLive do
  use Phoenix.LiveView
  alias Client.Trains

  def render(assigns) do
    if assigns[:loading] do
      render_loading(assigns)
    else
      render_log(assigns)
    end
  end

  defp render_loading(assigns) do
    ~L"""
    <div class="m-4">Loading...</div>
    """
  end

  defp render_log(assigns) do
    ~L"""
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
          @socket,
          ClientWeb.TrainLogAddSightingButton,
          id: :add_sighting_button
        ) %>
      </div>
    </div>
    """
  end

  def mount(_params, session, socket) do
    if connected?(socket) do
      assigns = [
        loading: false,
        log: Trains.get_log(session["user_id"], session["id"]),
        sightings: []
      ]

      {:ok, assign(socket, assigns)}
    else
      {:ok, assign(socket, :loading, true)}
    end
  end
end
