defmodule ClientWeb.Soap.OrderIngredientController do
  use ClientWeb, :controller
  alias Client.Session
  alias Client.Soap

  plug :put_view, ClientWeb.Soap.OrderIngredientView

  def new(conn, %{"order_id" => order_id}) do
    changeset = Soap.new_ingredient_changeset()
    render(conn, "new.html", changeset: changeset, order_id: order_id)
  end

  def create(conn, params) do
    order_id = Map.fetch!(params, "order_id")
    user_id = Session.current_user_id(conn)

    ingredient_params =
      params
      |> Map.get("ingredient")
      |> Map.put("order_id", order_id)

    {_, ingredient_params} =
      Map.get_and_update(ingredient_params, "depleted_at", fn value ->
        case value do
          "true" -> {value, DateTime.utc_now()}
          _ -> {value, nil}
        end
      end)

    case Soap.create_ingredient(ingredient_params, user_id) do
      {:ok, _ingredient} ->
        redirect(conn, to: Routes.soap_order_path(conn, :show, order_id))

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

    {_, ingredient_params} =
      Map.get_and_update(ingredient_params, "depleted_at", fn value ->
        case value do
          "true" -> {value, DateTime.utc_now()}
          _ -> {value, nil}
        end
      end)

    insert_result =
      user_id
      |> Soap.get_order_ingredient(order_id, id)
      |> Soap.update_ingredient(ingredient_params)

    case insert_result do
      {:ok, ingredient} ->
        redirect(conn, to: Routes.soap_order_path(conn, :show, ingredient.order_id))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
