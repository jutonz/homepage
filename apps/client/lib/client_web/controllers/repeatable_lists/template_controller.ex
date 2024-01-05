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
end
