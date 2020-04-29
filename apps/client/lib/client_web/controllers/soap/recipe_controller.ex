defmodule ClientWeb.Soap.RecipeController do
  use ClientWeb, :controller
  alias Client.Session
  alias Client.Soap

  def index(conn, _params) do
    recipes = conn |> Session.current_user_id() |> Soap.list_recipes()
    render(conn, "index.html", recipes: recipes)
  end

  def new(conn, _params) do
    changeset = Soap.new_recipe_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"recipe" => recipe_params} = _params) do
    insert_result =
      recipe_params
      |> Map.put("user_id", Session.current_user_id(conn))
      |> Soap.create_recipe()

    case insert_result do
      {:ok, recipe} ->
        redirect(conn, to: soap_recipe_path(conn, :show, recipe.id))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id} = _params) do
    recipe =
      conn
      |> Session.current_user_id()
      |> Soap.get_recipe(id)

    render(conn, "show.html", recipe: recipe)
  end

  def edit(conn, %{"id" => id} = _params) do
    changeset =
      conn
      |> Session.current_user_id()
      |> Soap.get_recipe(id)
      |> Soap.recipe_changeset()

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"recipe" => recipe_params, "id" => id} = _params) do
    user_id = Session.current_user_id(conn)
    recipe_params = Map.put(recipe_params, "user_id", user_id)

    insert_result =
      user_id
      |> Soap.get_recipe(id)
      |> Soap.update_recipe(recipe_params)

    case insert_result do
      {:ok, recipe} ->
        redirect(conn, to: soap_recipe_path(conn, :show, recipe.id))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_id = Session.current_user_id(conn)

    case Soap.delete_recipe(user_id, id) do
      {:ok, _log} ->
        redirect(conn, to: soap_recipe_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> put_flash(:danger, "Failed to delete")
        |> redirect(to: soap_recipe_path(conn, :index))
    end
  end
end
