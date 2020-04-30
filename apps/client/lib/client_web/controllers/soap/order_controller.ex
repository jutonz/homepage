defmodule ClientWeb.Soap.OrderController do
  use ClientWeb, :controller
  alias Client.Session
  alias Client.Soap

  def index(conn, _params) do
    orders = conn |> Session.current_user_id() |> Soap.list_orders()
    render(conn, "index.html", orders: orders)
  end

  def new(conn, _params) do
    changeset = Soap.new_order_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"order" => order_params} = _params) do
    insert_result =
      order_params
      |> Map.put("user_id", Session.current_user_id(conn))
      |> Soap.create_order()

    case insert_result do
      {:ok, order} ->
        redirect(conn, to: soap_order_path(conn, :show, order.id))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id} = _params) do
    order =
      conn
      |> Session.current_user_id()
      |> Soap.get_order(id)

    render(conn, "show.html", order: order)
  end

  def edit(conn, %{"id" => id} = _params) do
    changeset =
      conn
      |> Session.current_user_id()
      |> Soap.get_order(id)
      |> Soap.order_changeset()

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"order" => order_params, "id" => id} = _params) do
    user_id = Session.current_user_id(conn)
    order_params = Map.put(order_params, "user_id", user_id)

    insert_result =
      user_id
      |> Soap.get_order(id)
      |> Soap.update_order(order_params)

    case insert_result do
      {:ok, order} ->
        redirect(conn, to: soap_order_path(conn, :show, order.id))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_id = Session.current_user_id(conn)

    case Soap.delete_order(user_id, id) do
      {:ok, _log} ->
        redirect(conn, to: soap_order_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> put_flash(:danger, "Failed to delete")
        |> redirect(to: soap_order_path(conn, :index))
    end
  end
end
