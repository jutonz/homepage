defmodule ClientWeb.Soap.BatchIngredientController do
  use ClientWeb, :controller
  alias Client.Session
  alias Client.Soap

  plug :put_view, ClientWeb.Soap.BatchIngredientView

  def new(conn, %{"batch_id" => batch_id}) do
    changeset = Soap.new_batch_ingredient_changeset(%{batch_id: batch_id})
    render(conn, "new.html", changeset: changeset, batch_id: batch_id)
  end

  def create(conn, %{"ingredient" => ingredient} = params) do
    batch_id = Map.fetch!(params, "batch_id")

    attrs =
      ingredient
      |> Map.put("batch_id", batch_id)
      |> Map.put("user_id", Session.current_user_id(conn))

    case Soap.create_batch_ingredient(attrs) do
      {:ok, _ingredient} ->
        redirect(conn, to: Routes.soap_batch_path(conn, :show, batch_id))

      {:error, changeset} ->
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
      |> Soap.batch_ingredient_changeset()

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, params) do
    batch_id = Map.fetch!(params, "batch_id")
    id = Map.fetch!(params, "id")
    user_id = Session.current_user_id(conn)

    batch_ingredient_params =
      params
      |> Map.fetch!("ingredient")
      |> Map.put("user_id", user_id)

    update_result =
      user_id
      |> Soap.get_batch_ingredient(batch_id, id)
      |> Soap.update_batch_ingredient(batch_ingredient_params)

    case update_result do
      {:ok, _ingredient} ->
        redirect(conn, to: Routes.soap_batch_path(conn, :show, batch_id))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, params) do
    id = Map.fetch!(params, "id")
    batch_id = Map.fetch!(params, "batch_id")
    user_id = Session.current_user_id(conn)

    case Soap.delete_batch_ingredient(user_id, batch_id, id) do
      {:ok, batch_ingredient} ->
        batch_id = batch_ingredient.batch_id
        redirect(conn, to: Routes.soap_batch_path(conn, :show, batch_id))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
