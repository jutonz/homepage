defmodule ClientWeb.Components.RepeatableLists.TemplateItem do
  use ClientWeb, :live_component
  alias Client.RepeatableLists

  def render(assigns) do
    assigns =
      assigns
      |> assign_new(:changeset, fn ->
        assigns.item |> RepeatableLists.template_item_changeset()
      end)
      |> assign_new(:form, fn asgn -> to_form(asgn.changeset) end)

    ~H"""
    <form phx-change="save" phx-submit="save" phx-target={@myself} class="mb-0" data-role="item-form">
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
    """
  end

  def handle_event("save", params, socket) do
    item = socket.assigns[:item]

    cset =
      case RepeatableLists.update_template_item(item, params) do
        {:ok, item} -> RepeatableLists.template_item_changeset(item)
        {:error, cset} -> cset
      end

    {:noreply, assign(socket, changeset: cset, form: to_form(cset))}
  end

  defp name_value(form) do
    Phoenix.HTML.Form.normalize_value("text", form[:name].value)
  end
end
