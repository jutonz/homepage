defmodule ClientWeb.RepeatableLists.TemplateCloneController do
  use ClientWeb, :viewless_controller
  alias Client.RepeatableLists
  alias Client.RepeatableLists.List
  alias Client.Session

  def new(conn, %{"template_id" => id}) do
    conn
    |> Session.current_user_id()
    |> RepeatableLists.get_template(id)
    |> case do
      nil ->
        conn
        |> put_flash(:info, "No such template")
        |> redirect(to: ~p"/repeatable-lists/templates")

      template ->
        changeset =
          RepeatableLists.list_changeset(
            %List{},
            %{
              template_id: template.id,
              name: template.name,
              description: template.description
            }
          )

        render(
          conn,
          "new.html",
          template: template,
          changeset: changeset
        )
    end
  end

  def create(conn, %{"template_id" => id, "list" => list_params}) do
    template =
      conn
      |> Session.current_user_id()
      |> RepeatableLists.get_template(id)

    template
    |> RepeatableLists.create_list_from_template(list_params)
    |> case do
      {:ok, list} ->
        redirect(conn, to: ~p"/repeatable-lists/#{list.id}")

      _ ->
        conn
        |> put_flash(:error, "Unable to clone list")
        |> render("new.html", template: template)
    end
  end
end
