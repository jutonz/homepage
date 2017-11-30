defmodule HomepageWeb.PageController do
  use HomepageWeb, :controller

  def index(conn, _params) do
    conn |> render(:index)
  end
end
