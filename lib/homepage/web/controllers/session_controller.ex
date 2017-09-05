defmodule Homepage.Web.SessionController do
  use Homepage.Web, :controller

  def login(conn, _params) do
    render conn, :login
  end

  def authenticate(conn, params) do
    authenticated = true

    if authenticated do
      redirect conn, to: "/hello"
    end
  end

  def signup(conn, _params) do
    render conn, :signup
  end
end
