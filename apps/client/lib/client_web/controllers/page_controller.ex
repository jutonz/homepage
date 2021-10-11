defmodule ClientWeb.PageController do
  use ClientWeb, :controller

  def index(conn, _params) do
    title =
      if Mix.env() == :prod do
        "jutonz.com"
      else
        "[dev] jutonz.com"
      end

    conn
    |> assign(:title, title)
    |> render("index.html", layout: {ClientWeb.LayoutView, "react.html"})
  end
end
