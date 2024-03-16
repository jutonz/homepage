defmodule ClientWeb.Components.RepeatableLists.Item do
  use ClientWeb, :live_component
  alias Client.RepeatableLists

  def render(assigns) do
    assigns =
      assigns
      |> assign_new(:changeset, fn ->
        assigns.item |> RepeatableLists.item_changeset()
      end)
      |> assign_new(:form, fn asgn -> to_form(asgn.changeset) end)
      |> assign_new(:checked, fn asgn -> !!asgn[:form].data.completed_at end)

    ~H"""
    <div class="flex" data-item-id={@form.data.id}>
      <div
        class="flex items-center w-[30px]"
        role="button"
        phx-click="toggle_complete"
        phx-target={@myself}
      >
        <input type="checkbox" checked={@checked} />
      </div>
      <form
        phx-change="save"
        phx-submit="save"
        phx-target={@myself}
        class="mb-0"
        data-role="item-form"
      >
        <div phx-feedback-for="name">
          <input
            type="text"
            name="name"
            value={name_value(@form)}
            class="bg-transparent text-white border-transparent hover:border-current"
            phx-debounce="300"
          />
          <.error_messages field={@form[:name]} />
        </div>
      </form>
    </div>
    """
  end

  def handle_event("save", params, socket) do
    item = socket.assigns[:item]

    cset =
      case RepeatableLists.update_item(item, params) do
        {:ok, item} -> RepeatableLists.item_changeset(item)
        {:error, cset} -> cset
      end

    {:noreply, assign(socket, changeset: cset, form: to_form(cset))}
  end

  def handle_event("toggle_complete", _params, socket) do
    item = socket.assigns[:item]

    attrs =
      if item.completed_at do
        %{completed_at: nil}
      else
        %{completed_at: DateTime.utc_now()}
      end

    cset =
      case RepeatableLists.update_item(item, attrs) do
        {:ok, item} -> RepeatableLists.item_changeset(item)
        {:error, cset} -> cset
      end

    {:noreply, assign(socket, changeset: cset, form: to_form(cset))}
  end

  defp name_value(form) do
    Phoenix.HTML.Form.normalize_value("text", form[:name].value)
  end
end
