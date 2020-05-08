defmodule ClientWeb.Soap.BatchIngredientController do
  use ClientWeb, :controller
  alias Client.Session
  alias Client.Soap

  def new(conn, %{"batch_id" => batch_id}) do
    changeset = Soap.BatchIngredient.changeset(%{}, %{batch_id: batch_id})
    render(conn, "new.html", changeset: changeset, batch_id: batch_id)
  end

  def create(conn, %{"ingredient" => ingredient} = params) do
    batch_id = Map.fetch!(params, "batch_id")

    attrs = %{
      batch_id: batch_id,
      ingredient_id: Map.fetch!(ingredient, "ingredient_id"),
      user_id: Session.current_user_id(conn)
    }

    case Soap.create_batch_ingredient(attrs) |> IO.inspect() do
      {:ok, _ingredient} ->
        redirect(conn, to: soap_batch_path(conn, :show, batch_id))

      {:error, changeset} ->
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset, batch_id: batch_id)
    end
  end

  def edit(conn, params) do
    batch_id = Map.fetch!(params, "batch_id")
    id = Map.fetch!(params, "id")

    changeset =
      conn
      |> Session.current_user_id()
      |> Soap.get_batch_ingredient(batch_id, id)
      |> Soap.ingredient_changeset()

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, params) do
    batch_id = Map.fetch!(params, "batch_id")
    id = Map.fetch!(params, "id")
    user_id = Session.current_user_id(conn)

    ingredient_params =
      params
      |> Map.fetch!("ingredient")
      |> Map.put("user_id", user_id)

    insert_result =
      user_id
      |> Soap.get_batch_ingredient(batch_id, id)
      |> Soap.update_ingredient(ingredient_params)

    case insert_result do
      {:ok, ingredient} ->
        redirect(conn, to: soap_batch_path(conn, :show, ingredient.batch_id))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
