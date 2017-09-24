defmodule HomepageWeb.PageController do
  use HomepageWeb, :controller

  def index(conn, _params) do
    redirect conn, to: "/login"
  end
end
