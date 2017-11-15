defmodule HomepageWeb.Router do
  use HomepageWeb, :router
  import HomepageWeb.Helpers.UserSession

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticated_route do
    plug :load_user_or_redirect
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

    pipe_through :authenticated_route
    # From this point on users will be redirected to /login if trying to access
    # one of these routes while unauthenticated.

    get "/home", HomeController, :index
    get "/home/:messenger", HomeController, :show
    get "/home/blah", HomeController, :wee
  end

  scope "/api", HomepageWeb do
    pipe_through :api
  end
end
