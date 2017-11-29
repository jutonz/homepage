defmodule HomepageWeb.SettingsController do
  use HomepageWeb, :controller

  def index(conn, _params) do
    conn |> render(:index)
  end
end
