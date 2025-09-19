defmodule ClientWeb.Soap.IngredientController do
  use ClientWeb, :controller
  alias Client.Session
  alias Client.Soap

  plug :put_view, ClientWeb.Soap.IngredientView

  def index(conn, _params) do
    ingredients =
      conn
      |> Session.current_user_id()
      |> Soap.list_ingredients()

    render(conn, "index.html", ingredients: ingredients)
  end

  def show(conn, %{"id" => id} = _params) do
    ingredient =
      conn
      |> Session.current_user_id()
      |> Soap.get_ingredient(id)
      |> Client.Repo.preload(:order)
      |> Client.Repo.preload(batch_ingredients: [:batch])

    render(conn, "show.html", ingredient: ingredient)
  end
end
