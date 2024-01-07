defmodule ClientWeb.Live.RepeatableLists.FormComponent do
  use ClientWeb, :live_view
  alias Client.RepeatableLists

  def render(assigns) do
    ~H"""
    <.simple_form for={@form} phx-submit="submit">
      <.input field={@form[:name]} label="Name" />
      <.input field={@form[:description]} label="Description" />

      <p>
        You can add items and sections on the next page.
      </p>

      <:actions>
        <button class="button"><%= @action %></button>
      </:actions>
    </.simple_form>
    """
  end

  def mount(_params, session, socket) do
    changeset = RepeatableLists.new_template_changeset()

    {:ok,
     assign(socket,
       form: to_form(changeset),
       action: Map.fetch!(session, "action"),
       user_id: Map.fetch!(session, "user_id")
     )}
  end

  def handle_event("submit", %{"template" => template_params}, socket) do
    user_id = socket.assigns[:user_id]

    case RepeatableLists.create_template(user_id, template_params) do
      {:ok, template} ->
        socket =
          socket
          |> put_flash(:info, "created template")
          |> redirect(to: ~p"/repeatable-lists/templates/#{template.id}")

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
