defmodule ClientWeb.Soap.OrderIngredientController do
  use ClientWeb, :controller
  alias Client.Session
  alias Client.Soap

  def new(conn, %{"order_id" => order_id}) do
    changeset = Soap.new_ingredient_changeset()
    render(conn, "new.html", changeset: changeset, order_id: order_id)
  end

  def create(conn, params) do
    order_id = Map.fetch!(params, "order_id")

    insert_result =
      params
      |> Map.get("ingredient")
      |> Map.put("order_id", order_id)
      |> Soap.create_ingredient()

    case insert_result do
      {:ok, _ingredient} ->
        redirect(conn, to: soap_order_path(conn, :show, order_id))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, order_id: order_id)
    end
  end

  def edit(conn, params) do
    order_id = Map.fetch!(params, "order_id")
    id = Map.fetch!(params, "id")

    changeset =
      conn
      |> Session.current_user_id()
      |> Soap.get_order_ingredient(order_id, id)
      |> Soap.ingredient_changeset()

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, params) do
    order_id = Map.fetch!(params, "order_id")
    id = Map.fetch!(params, "id")
    user_id = Session.current_user_id(conn)

    ingredient_params =
      params
      |> Map.fetch!("ingredient")
      |> Map.put("user_id", user_id)

    insert_result =
      user_id
      |> Soap.get_order_ingredient(order_id, id)
      |> Soap.update_ingredient(ingredient_params)

    case insert_result do
      {:ok, ingredient} ->
        redirect(conn, to: soap_order_path(conn, :show, ingredient.order_id))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
