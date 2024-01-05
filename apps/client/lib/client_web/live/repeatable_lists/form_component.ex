defmodule ClientWeb.Live.RepeatableLists.FormComponent do
  use ClientWeb, :live_view

  def render(assigns) do
    ~H"""
    <%= form_for(
      @changeset,
      @submit_path,
    fn form -> %>
      <div class="flex flex-1 flex-col mb-6">
        <div>
          <%= label(form, :name, "Name") %>
          <%= text_input(
            form,
            :name,
            class: "mt-2",
            autofocus: true,
            data: [role: "list-template-name-input"]
          ) %>
          <div class="text-red-600 mt-1">
            <%= error_tag(form, :name) %>
          </div>
        </div>

        <div>
          <%= label(form, :description, "Description") %>
          <%= text_input(
            form,
            :description,
            class: "mt-2",
            data: [role: "list-template-description-input"]
          ) %>
          <div class="text-red-600 mt-1">
            <%= error_tag(form, :description) %>
          </div>
        </div>
      </div>

      <%= submit(
        @action,
        class: "button",
        data: [role: "list-template-submit"]
      ) %>
    <% end) %>
    """
  end

  def mount(_params, session, socket) do
    {:ok, assign(socket,
      changeset: Map.fetch!(session, "changeset"),
      submit_path: Map.fetch!(session, "submit_path"),
      action: Map.fetch!(session, "action")
    )}
  end
end
