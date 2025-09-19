defmodule ClientWeb.PageController do
  use ClientWeb, :controller

  plug :put_view, ClientWeb.PageView

  def index(conn, _params) do
    title =
      if Application.fetch_env!(:client, :env) == :prod do
        "jutonz.com"
      else
        "[dev] jutonz.com"
      end

    conn
    |> assign(:title, title)
    |> render("index.html", layout: {ClientWeb.Layouts, :react})
  end
end
