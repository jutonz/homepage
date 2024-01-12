defmodule ClientWeb.Soap.BatchController do
  use ClientWeb, :controller
  alias Client.Session
  alias Client.Soap

  def index(conn, _params) do
    batches = conn |> Session.current_user_id() |> Soap.list_batches()
    render(conn, "index.html", batches: batches)
  end

  def new(conn, _params) do
    changeset = Soap.new_batch_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"batch" => batch_params} = _params) do
    insert_result =
      batch_params
      |> Map.put("user_id", Session.current_user_id(conn))
      |> Soap.create_batch()

    case insert_result do
      {:ok, batch} ->
        redirect(conn, to: Routes.soap_batch_path(conn, :show, batch.id))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id} = _params) do
    batch =
      conn
      |> Session.current_user_id()
      |> Soap.get_batch_with_ingredients(String.to_integer(id))

    render(conn, "show.html", batch: batch)
  end

  def edit(conn, %{"id" => id} = _params) do
    batch =
      conn
      |> Session.current_user_id()
      |> Soap.get_batch(id)

    changeset = Soap.batch_changeset(batch)

    render(conn, "edit.html", changeset: changeset, batch: batch)
  end

  def update(conn, %{"batch" => batch_params, "id" => id} = _params) do
    user_id = Session.current_user_id(conn)
    batch_params = Map.put(batch_params, "user_id", user_id)

    insert_result =
      user_id
      |> Soap.get_batch(id)
      |> Soap.update_batch(batch_params)

    case insert_result do
      {:ok, batch} ->
        redirect(conn, to: Routes.soap_batch_path(conn, :show, batch.id))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_id = Session.current_user_id(conn)

    case Soap.delete_batch(user_id, id) do
      {:ok, _log} ->
        redirect(conn, to: Routes.soap_batch_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> put_flash(:danger, "Failed to delete")
        |> redirect(to: Routes.soap_batch_path(conn, :index))
    end
  end
end
