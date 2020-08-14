defmodule ClientWeb.Router do
  use ClientWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug
  import Phoenix.LiveView.Router

  ##############################################################################
  # Browser requests
  ##############################################################################

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:fetch_live_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)

    if Mix.env() == :test do
      plug(ClientWeb.Plugs.TestAuthHelper)
    end
  end

  pipeline :browser_authenticated do
    plug(ClientWeb.Plugs.BrowserAuthenticated)
  end

  scope "/", ClientWeb do
    pipe_through(:browser)
    pipe_through(:browser_authenticated)

    resources("/food-logs", FoodLogController)

    resources("/water-logs", WaterLogController, only: ~w[index new create show]a) do
      resources("/filters", WaterFilterController, only: ~w[index create delete]a, as: :filters)
      live("/kiosk", WaterLogKioskLive, layout: {ClientWeb.LayoutView, :app})
    end

    scope("/settings", Settings, as: :settings) do
      resources("/api", ApiController, singleton: true, only: ~w[show]a) do
        resources("/tokens", TokenController, only: ~w[new create delete]a)
      end
    end

    scope("/soap", Soap, as: :soap) do
      get("/", SoapController, :index)

      resources("/ingredients", IngredientController, only: ~w[index]a)

      resources("/batches", BatchController) do
        resources(
          "/ingredients",
          BatchIngredientController,
          as: :ingredient,
          only: ~w[new create edit update]a
        )
      end

      resources("/orders", OrderController) do
        resources(
          "/ingredients",
          OrderIngredientController,
          as: :ingredient,
          only: ~w[new create edit update]a
        )
      end
    end
  end

  scope "/twitch", ClientWeb.Twitch do
    pipe_through(:browser)

    get("/channels/:name", ChannelController, :show)
  end

  ##############################################################################
  # Graphql API's
  ##############################################################################

  pipeline :graphql_api do
    plug(:accepts, ["json"])

    plug(
      Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
      pass: ["*/*"],
      json_decoder: Poison
    )

    plug(ClientWeb.Plugs.Context)
  end

  scope "/graphql" do
    pipe_through(:graphql_api)

    forward("/", Absinthe.Plug, schema: ClientWeb.Schema)
  end

  Absinthe.Plug.GraphiQL

  if Mix.env() == :dev do
    forward(
      "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: ClientWeb.Schema,
      interface: :advanced,
      context: %{pubsub: ClientWeb.Endpoint}
    )
  end

  ##############################################################################
  # Non Graphql API's
  ##############################################################################

  pipeline(:api) do
    plug(:accepts, ["json"])
    plug(:fetch_session)
  end

  pipeline(:authenticated_api) do
    plug(ClientWeb.Plugs.ApiAuthenticated)
  end

  if Mix.env() == :dev do
    forward("/sent_emails", Bamboo.SentEmailViewerPlug)
  end

  scope "/api", ClientWeb do
    pipe_through(:api)

    get("/healthz", HealthController, :check)

    post("/login", SessionController, :login)
    post("/logout", SessionController, :logout)

    get("/whatismyip", ClientInfoController, :whatismyip)

    scope "/twitch", Twitch, as: :twitch do
      scope "/subscriptions", Subscriptions, as: :subscriptions do
        get("/log", CallbackController, :log, as: :log)
        get("/:id", CallbackController, :confirm)
        post("/:id", CallbackController, :callback)
      end
    end

    pipe_through(:authenticated_api)

    get("/tokentest", SessionController, :token_test)

    scope "/", Api, as: :api do
      resources "/water-logs", WaterLog, only: [] do
        resources("/entries", WaterLogEntryController, as: :entry, only: ~w[create]a)
      end
    end
  end

  scope "/twitch", ClientWeb do
    get("/login", TwitchController, :login)
    get("/oauth", TwitchController, :exchange)

    get("/failurelog", TwitchController, :failurelog)
  end
end
