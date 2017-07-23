defmodule Homepage.Web.SessionController do
  use Homepage.Web, :controller

  def index(conn, _params) do
    render conn, :index
  end
end
