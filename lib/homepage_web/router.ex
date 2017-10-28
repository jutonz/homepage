defmodule HomepageWeb.Router do
  use HomepageWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HomepageWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/healthz", HealthController, :index

    get  "/signup", SessionController, :show_signup
    post "/signup", SessionController, :signup

    get  "/login",  SessionController, :show_login
    post "/login",  SessionController, :login
    post "/logout", SessionController, :logout

    get "/home", HomeController, :index
    get "/home/:messenger", HomeController, :show
    get "/home/blah", HomeController, :wee
  end

  scope "/api", HomepageWeb do
    pipe_through :api
  end
end
