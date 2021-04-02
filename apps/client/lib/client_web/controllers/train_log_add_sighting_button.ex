defmodule ClientWeb.TrainLogAddSightingButton do
  use ClientWeb, :live_component
  alias Client.Trains

  def render(assigns) do
    if assigns[:changeset] do
      render_form(assigns)
    else
      render_button(assigns)
    end
  end

  defp render_form(assigns) do
    ~L"""
    <%= form = form_for @changeset, "#", [phx_submit: "save"] %>
      <div class="flex flex-1 flex-col">
        <%= label(form, :location, "Location") %>
        <%= text_input(
          form,
          :location,
          class: "mt-2",
          autofocus: true,
          data: [role: "water-log-location-input"]
        ) %>
        <div class="text-red-600 mt-1">
          <%= error_tag(form, :location) %>
        </div>
      </div>

      <%= submit(
        "Create",
        class: "w-32 mt-4",
        data: [role: "create-train-sighting"]
      ) %>
    </form>

    <button phx-click="cancel-add-sighting">
      Cancel
    </button>
    """
  end

  defp render_button(assigns) do
    ~L"""
    <button phx-click="add-sighting" phx-target="<%= @myself %>">
      Add sighting
    </button>
    """
  end

  def handle_event("add-sighting", _params, socket) do
    assigns = [
      changeset: Trains.new_sighting_changeset()
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("cancel-add-sighting", _params, socket) do
    {:noreply, assign(socket, :changeset, nil)}
  end
end
