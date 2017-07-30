defmodule Homepage.Web.PageController do
  use Homepage.Web, :controller

  def index(conn, _params) do
    redirect conn, to: "/login"
  end
end
