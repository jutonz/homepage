defmodule Homepage.Web.HelloController do
  use Homepage.Web, :controller

  def index(conn, _params) do
    case get_session(conn, :user_id) do
      nil ->
        render conn, :index
      user_id ->
        user = Homepage.Repo.get(Homepage.User, user_id)
        redirect conn, to: "/hello/#{user.email}"
    end
  end

  def show(conn, %{"messenger" => messenger}) do
    render conn, :show, messenger: messenger
  end
end
