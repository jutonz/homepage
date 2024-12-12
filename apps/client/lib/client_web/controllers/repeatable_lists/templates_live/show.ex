defmodule ClientWeb.RepeatableLists.TemplatesLive.Show do
  use ClientWeb, :live_view
  alias Client.RepeatableLists

  def render(assigns) do
    ~H"""
    <div class="m-4">
      <ClientWeb.Components.Breadcrumbs.breadcrumbs>
        <:crumb title="Repeatable lists" href={~p"/repeatable-lists/templates"} />
        <span data-role="name">{@template.name}</span>
      </ClientWeb.Components.Breadcrumbs.breadcrumbs>

      <%= if @template.description do %>
        <div>{@template.description}</div>
      <% end %>

      <.delete_button />
      <.link href={~p"/repeatable-lists/templates/#{@template.id}/clones/new"} class="button mt-10">
        Clone
      </.link>

      <hr class="my-3" />

      <div>
        <%= for item <- @template.items do %>
          <.live_component
            module={ClientWeb.Components.RepeatableLists.TemplateItem}
            id={"item-#{item.id}"}
            item={item}
          />
        <% end %>

        <.live_component
          module={ClientWeb.Components.RepeatableLists.AddItemToTemplateButton}
          id="new-item-btn"
          template={@template}
        />

        <%= for section <- @template.sections do %>
          <.live_component
            module={ClientWeb.Components.RepeatableLists.TemplateSection}
            id={"section-#{section.id}"}
            section={section}
            template={@template}
          />
        <% end %>

        <button phx-click={show_modal("new-section")} class="button button--inline mt-2">
          + Add section
        </button>
      </div>

      <div>
        <%= if Enum.any?(@template.lists) do %>
          <hr class="my-3" />
          <h3 class="text-xl mb-3">Lists</h3>
        <% end %>

        <%= for list <- @template.lists do %>
          <div class="mb-3">
            <.link href={~p"/repeatable-lists/#{list.id}"}>
              {list.name}
            </.link>
          </div>
        <% end %>
      </div>

      <.modal id="new-section">
        <h1 class="text-2xl mb-4">New section</h1>
        <.simple_form
          for={@new_section_changeset}
          phx-submit="save_new_section"
          data-role="new-section-form"
        >
          <.input field={@new_section_changeset[:name]} label="Name" autofocus />
          <:actions>
            <.button>Save</.button>
          </:actions>
        </.simple_form>
      </.modal>
    </div>
    """
  end

  def mount(%{"id" => id}, %{"user_id" => user_id}, socket) do
    template = RepeatableLists.get_template(user_id, id)
    section_changeset = RepeatableLists.new_template_section_changeset()

    socket =
      assign(socket,
        template: template,
        new_section_changeset: to_form(section_changeset)
      )

    {:ok, socket, layout: {ClientWeb.LayoutView, :app}}
  end

  def handle_event("delete", _params, socket) do
    template = socket.assigns[:template]

    socket =
      case RepeatableLists.delete_template(template) do
        {:ok, _template} ->
          socket
          |> put_flash(:info, "Deleted template")
          |> redirect(to: ~p"/repeatable-lists/templates")

        {:error, _changeset} ->
          socket
          |> put_flash(:error, "Failed to delete template")
      end

    {:noreply, socket}
  end

  def handle_event("add_section", _params, socket) do
    template = socket.assigns[:template]

    changeset =
      template
      |> Ecto.build_assoc(:sections)
      |> RepeatableLists.template_section_changeset()

    {:noreply, assign(socket, new_section_changeset: to_form(changeset))}
  end

  def handle_event("save_new_section", %{"template_section" => params}, socket) do
    template = socket.assigns[:template]

    socket =
      case RepeatableLists.create_template_section(template.id, params) do
        {:ok, _section} -> redirect(socket, to: ~p"/repeatable-lists/templates/#{template.id}")
        {:error, changeset} -> assign(socket, new_section_changeset: to_form(changeset))
      end

    {:noreply, socket}
  end

  def delete_button(assigns) do
    ~H"""
    <button type="button" phx-click={show_modal("delete-confirm")} class="button button--danger mt-10">
      Delete template
    </button>

    <.modal id="delete-confirm">
      <h1 class="text-2xl mb-4">Delete list template?</h1>
      <p class="mb-4">This will also delete any lists created from this template.</p>
      <p class="mb-4">Are you sure?</p>

      <button phx-click="delete" class="button button--danger mt-10">
        Delete template
      </button>
    </.modal>
    """
  end
end
