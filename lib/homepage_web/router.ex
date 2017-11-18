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

  pipeline :graphql_api do
    plug :accepts, ["json"]


    # These don't work
    # Guardian seems nice but is really a pain in the ass to set up.
    #plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    #plug Guardian.Plug.LoadResource


    plug HomepageWeb.Plugs.Context

    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
      pass: ["*/*"],
      json_decoder: Poison

    #plug Absinthe.Plug,
      #schema: HomepageWeb.Schema
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

  scope "/api/graphql" do
    pipe_through :graphql_api

    forward "/", Absinthe.Plug,
      schema: HomepageWeb.Schema
  end


  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: HomepageWeb.Schema,
    interface: :advanced,
    context: %{pubsub: HomepageWeb.Endpoint}
end
