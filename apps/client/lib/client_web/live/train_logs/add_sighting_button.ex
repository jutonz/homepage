defmodule ClientWeb.TrainLogs.AddSightingButton do
  use ClientWeb, :live_component
  alias Client.Trains

  def render(assigns) do
    rendered =
      if assigns[:changeset] do
        render_form(assigns)
      else
        render_button(assigns)
      end

    assigns = assign(assigns, :rendered, rendered)

    ~H"""
    <div id={@myself}>
      <%= @rendered %>
    </div>
    """
  end

  defp render_form(assigns) do
    ~H"""
    <.form :let={form} for={@changeset} phx-submit="save" phx-target={@myself}>
      <div class="flex flex-1 flex-col mt-2">
        <div class="flex flex-row">
          <%= label(form, :sighted_date, "Date") %>
          <span class="text-red-600 ml-2">
            <%= error_tag(form, :sighted_date) %>
          </span>
        </div>
        <%= date_input(
          form,
          :sighted_date,
          class: "mt-2",
          data: [role: "train-log-sighted-date-input"]
        ) %>
      </div>

      <div class="flex flex-1 flex-col mt-2">
        <div class="flex flex-row">
          <%= label(form, :sighted_time, "Time") %>
          <span class="text-red-600 ml-2">
            <%= error_tag(form, :sighted_time) %>
          </span>
        </div>
        <%= time_input(
          form,
          :sighted_time,
          class: "mt-2",
          data: [role: "train-log-sighted-time-input"]
        ) %>
      </div>

      <div class="flex flex-1 flex-col">
        <div class="flex flex-row mt-2">
          <%= label(form, :direction, "Direction") %>
          <span class="text-red-600 ml-2">
            <%= error_tag(form, :direction) %>
          </span>
        </div>
        <div class="flex">
          <div>
            <%= radio_button(form, :direction, "North", id: "north") %>
            <%= label(form, :direction, "North", for: "north") %>
          </div>
          <div class="ml-2">
            <%= radio_button(form, :direction, "South", id: "south") %>
            <%= label(form, :direction, "South", for: "south") %>
          </div>
        </div>
      </div>

      <div class="flex flex-1 flex-col mt-2">
        <div class="flex flex-row">
          <%= label(form, :cars, "Cars") %>
          <span class="text-red-600 ml-2">
            <%= error_tag(form, :cars) %>
          </span>
        </div>
        <%= text_input(
          form,
          :cars,
          class: "mt-2",
          data: [role: "train-log-cars-input"]
        ) %>
      </div>

      <div class="flex flex-1 flex-col mt-2">
        <div class="flex flex-row">
          <%= label(form, :numbers, "Engine number (separate multiple by spaces)") %>
          <span class="text-red-600 ml-2">
            <%= error_tag(form, :numbers) %>
          </span>
        </div>
        <%= text_input(
          form,
          :numbers,
          class: "mt-2",
          data: [role: "train-log-numbers-input"],
          value: Enum.join(Ecto.Changeset.get_change(@changeset, :numbers, []), " ")
        ) %>
      </div>

      <div class="flex flex-row mt-4 justify-between">
        <%= submit(
          "Create",
          class: "button",
          data: [role: "create-train-sighting"]
        ) %>

        <button class="" phx-click="cancel" phx-target={@myself}>
          Cancel
        </button>
      </div>
    </.form>
    """
  end

  defp render_button(assigns) do
    ~H"""
    <button phx-click="add-sighting" phx-target={@myself} data-role="add-sighting-button">
      Add sighting
    </button>
    """
  end

  def handle_event("add-sighting", _params, socket) do
    now = now()

    params = %{
      sighted_date: DateTime.to_date(now),
      sighted_time: DateTime.to_time(now)
    }

    changeset = Trains.new_sighting_changeset(params)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, :changeset, nil)}
  end

  def handle_event("save", %{"sighting" => sighting_params}, socket) do
    sighting_params =
      Enum.reduce(sighting_params, %{}, fn {k, v}, acc ->
        Map.put(acc, String.to_atom(k), v)
      end)

    engines =
      sighting_params
      |> Map.get(:numbers)
      |> String.split(" ")
      |> Enum.filter(fn string -> string != "" end)
      |> Enum.map(&String.to_integer/1)

    sighting_params =
      sighting_params
      |> Map.put(:user_id, socket.assigns[:user_id])
      |> Map.put(:log_id, socket.assigns[:log_id])
      |> Map.put(:numbers, engines)

    assigns =
      case Trains.create_sighting(sighting_params) do
        {:ok, _sighting} ->
          # TODO: Add this sighting to the list
          send(self(), :reload_sightings)
          [changeset: nil]

        {:error, changeset} ->
          [changeset: changeset]
      end

    {:noreply, assign(socket, assigns)}
  end

  @default_timezone Application.compile_env!(:client, :default_timezone)
  defp now do
    DateTime.now!(@default_timezone)
  end
end
