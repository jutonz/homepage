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

  def create(conn, params) do
    user_id = Session.current_user_id(conn)

    # do this insert in live view
    case RepeatableLists.create_template(user_id, params) do
      {:ok, list} ->
        redirect(conn, to: Routes.reusable_lists_template_path(@endpoint, :show, list.id))
      {:error, changeset} ->
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset)
    end
  end
end
