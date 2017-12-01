defmodule HomepageWeb.Router do
  use HomepageWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :graphql_api do
    plug :accepts, ["json"]

    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
      pass: ["*/*"],
      json_decoder: Poison

    plug HomepageWeb.Plugs.Context
  end

  scope "/", HomepageWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/healthz", HealthController, :index

    post "/login",  SessionController, :login
    post "/logout", SessionController, :logout
    post "/signup", SessionController, :signup
  end

  scope "/graphql" do
    pipe_through :graphql_api

    forward "/", Absinthe.Plug,
      schema: HomepageWeb.Schema
  end


  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: HomepageWeb.Schema,
    interface: :advanced,
    context: %{pubsub: HomepageWeb.Endpoint}
end
