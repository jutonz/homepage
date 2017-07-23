defmodule Homepage.Web.PageController do
  use Homepage.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
