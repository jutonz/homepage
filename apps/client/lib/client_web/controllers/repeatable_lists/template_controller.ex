defmodule ClientWeb.RepeatableLists.TemplateController do
  use ClientWeb, :controller
  alias Client.RepeatableLists
  alias Client.Session

  def index(conn, _params) do
    lists =
      conn
      |> Session.current_user_id()
      |> RepeatableLists.list_templates()

    render(conn, "index.html", lists: lists)
  end

  def new(conn, _params) do
    changeset = RepeatableLists.new_template_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    conn
    |> Session.current_user_id()
    |> RepeatableLists.get_template(id)
    |> case do
      nil ->
        conn
        |> put_flash(:info, "No such template")
        |> redirect(to: ~p"/repeatable-lists")

      template ->
        render(conn, "show.html", template: template)
    end
  end
end
