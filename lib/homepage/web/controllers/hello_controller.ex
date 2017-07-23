defmodule Homepage.Web.HelloController do
  use Homepage.Web, :controller

  def index(conn, _params) do
    render conn, :index
  end

  def show(conn, %{"messenger" => messenger}) do
    render conn, :show, messenger: messenger
  end
end
