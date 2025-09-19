defmodule ClientWeb.Storage.ItemController do
  use ClientWeb, :controller

  alias Client.{
    Session,
    Storage
  }

  plug :put_view, ClientWeb.Storage.ItemView

  def new(conn, %{"context_id" => context_id}) do
    context =
      conn
      |> Session.current_user_id()
      |> Storage.get_context(context_id)

    changeset = Storage.new_item_changeset(context)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item" => item_params} = params) do
    context =
      conn
      |> Session.current_user_id()
      |> Storage.get_context(params["context_id"])

    {_, item_params} =
      Map.get_and_update(item_params, "unpacked_at", fn value ->
        case value do
          "true" -> {value, DateTime.utc_now()}
          _ -> {value, nil}
        end
      end)

    case Storage.create_item(context, item_params) do
      {:ok, _item} ->
        redirect(conn, to: Routes.storage_context_path(conn, :show, context))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, params) do
    user_id = Session.current_user_id(conn)
    context = Storage.get_context(user_id, params["context_id"])
    item = Storage.get_item(user_id, context.id, params["id"])
    changeset = Storage.item_changeset(item)

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"item" => item_params} = params) do
    user_id = Session.current_user_id(conn)
    context = Storage.get_context(user_id, params["context_id"])
    item = Storage.get_item(user_id, context.id, params["id"])

    item_params =
      item_params
      |> Map.put("context_id", context.id)

    {_, item_params} =
      Map.get_and_update(item_params, "unpacked_at", fn value ->
        case value do
          "true" -> {value, DateTime.utc_now()}
          _ -> {value, nil}
        end
      end)

    case Storage.update_item(item, item_params) do
      {:ok, _item} ->
        redirect(conn, to: Routes.storage_context_path(conn, :show, context))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, params) do
    user_id = Session.current_user_id(conn)
    context = Storage.get_context(user_id, params["context_id"])
    item = Storage.get_item(user_id, context.id, params["id"])
    {:ok, _item} = Storage.delete_item(item)
    redirect(conn, to: Routes.storage_context_path(conn, :show, context))
  end
end
