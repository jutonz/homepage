defmodule ClientWeb.Router do
  use ClientWeb, :router

  ##############################################################################
  # Browser requests
  ##############################################################################

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", ClientWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  ##############################################################################
  # Graphql API's
  ##############################################################################

  pipeline :graphql_api do
    plug :accepts, ["json"]

    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
      pass: ["*/*"],
      json_decoder: Poison

    plug ClientWeb.Plugs.Context
  end

  scope "/graphql" do
    pipe_through :graphql_api

    forward "/", Absinthe.Plug,
      schema: ClientWeb.Schema
  end

  Absinthe.Plug.GraphiQL

  if Mix.env() == "dev" do
    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: ClientWeb.Schema,
      interface: :advanced,
      context: %{ pubsub: ClientWeb.Endpoint }
  end

  ##############################################################################
  # Non Graphql API's
  ##############################################################################

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :protect_from_forgery
  end

  scope "/api", ClientWeb do
    pipe_through :api

    get "/healthz", HealthController, :check

    post "/login", SessionController, :login
    post "/logout", SessionController, :logout
    post "/signup", SessionController, :signup
  end
end
