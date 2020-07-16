defmodule ClientWeb.Soap.IngredientController do
  use ClientWeb, :controller
  alias Client.Session
  alias Client.Soap

  def index(conn, _params) do
    ingredients = conn |> Session.current_user_id() |> Soap.list_ingredients()
    render(conn, "index.html", ingredients: ingredients)
  end
end
