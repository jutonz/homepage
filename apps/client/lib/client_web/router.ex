defmodule ClientWeb.Router do
  # Phoenix has a couple of bad typespecs as of 1.4.11
  @dialyzer {:no_return, __checks__: 0}

  use ClientWeb, :router
  import Phoenix.LiveView.Router
  import Phoenix.LiveDashboard.Router

  defp basic_auth_runtime(conn, _opts) do
    username = Application.fetch_env!(:client, :admin_username)
    password = Application.fetch_env!(:client, :admin_password)
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end

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
    plug(:put_root_layout, {ClientWeb.Layouts, :root})

    if Application.compile_env!(:client, :env) == :test do
      plug(ClientWeb.Plugs.TestAuthHelper)
    end
  end

  pipeline :browser_authenticated do
    plug(ClientWeb.Plugs.BrowserAuthenticated)
  end

  pipeline :admin do
    plug(:basic_auth_runtime)
  end

  scope "/", ClientWeb do
    pipe_through(:browser)

    get("/", PageController, :index)

    pipe_through(:browser_authenticated)

    resources("/food-logs", FoodLogController, except: ~w[show]a)
    live("/food-logs/:id", FoodLogsLive.Show, :show)

    resources("/water-logs", WaterLogController, only: ~w[index new create show]a) do
      resources("/filters", WaterFilterController,
        only: ~w[index new create edit update delete]a,
        as: :filters
      )

      live_session(:water_logs, root_layout: {ClientWeb.Layouts, :app}) do
        live("/kiosk", WaterLogKioskLive)
      end
    end

    resources("/train-logs", TrainLogController, only: ~w[index new create show]a)

    scope("/settings", Settings, as: :settings) do
      resources("/api", ApiController, singleton: true, only: ~w[show]a) do
        resources("/tokens", TokenController, only: ~w[new create delete]a)
      end
    end

    scope("/soap", Soap, as: :soap) do
      get("/", SoapController, :index)

      resources("/ingredients", IngredientController, only: ~w[index show]a)

      resources("/batches", BatchController) do
        resources(
          "/ingredients",
          BatchIngredientController,
          as: :ingredient,
          only: ~w[new create edit update delete]a
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

    scope("/storage", Storage, as: :storage) do
      resources("/", ContextController) do
        resources("/export", ExportController, only: ~w[create]a)
        resources("/items", ItemController)
      end
    end

    scope("/repeatable-lists", RepeatableLists, as: :repeatable_lists) do
      get("/templates", TemplateController, :index)

      live("/:id", Live.Show, :show)

      resources(
        "/templates",
        TemplateController,
        only: ~w[new delete]a
      ) do
        resources("/clones", TemplateCloneController, only: ~w[new create]a)
      end

      live("/templates/:id", TemplatesLive.Show, :show)
    end
  end

  scope "/admin", ClientWeb do
    pipe_through(:browser)
    pipe_through(:admin)

    live_dashboard(
      "/dashboard",
      ecto_repos: [Client.Repo, Twitch.Repo],
      metrics: ClientWeb.Telemetry
    )
  end

  scope "/twitch", ClientWeb.Twitch, as: :twitch do
    pipe_through(:browser)

    resources("/channels", ChannelController, only: ~w[show]a) do
      resources("/updates", ChannelUpdateController, only: ~w[index]a)
    end
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
      json_decoder: Jason
    )

    plug(ClientWeb.Plugs.Context)
  end

  scope "/graphql" do
    pipe_through(:graphql_api)

    forward(
      "/",
      Absinthe.Plug,
      schema: ClientWeb.Schema,
      before_send: {Client.Session, :init_session_from_jwt}
    )
  end

  if Application.compile_env!(:client, :env) == :dev do
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

  if Application.compile_env!(:client, :env) == :dev do
    forward("/sent_emails", Bamboo.SentEmailViewerPlug)
  end

  get("/up", ClientWeb.HealthController, :check)

  scope "/api", ClientWeb do
    pipe_through(:api)

    get("/healthz", HealthController, :check)

    get("/whatismyip", ClientInfoController, :whatismyip)

    scope "/twitch", Twitch, as: :twitch do
      scope "/subscriptions", Subscriptions, as: :subscriptions do
        get("/log", CallbackController, :log, as: :log)
        get("/:id", CallbackController, :confirm)
        post("/:id", CallbackController, :callback)
      end
    end

    scope "/", Api, as: :api do
      get("/exchange", SessionController, :exchange)
      post("/logout", SessionController, :logout)

      pipe_through(:authenticated_api)
      get("/tokentest", SessionController, :token_test)
      post("/one-time-login-link", SessionController, :one_time_login_link)

      resources "/water-logs", WaterLog, only: [] do
        resources("/entries", WaterLogEntryController, as: :entry, only: ~w[create]a)
      end

      scope("/todoist", Todoist, as: :todoist) do
        resources("/laundry_tasks", LaundryTasksController, only: ~w[create]a)
      end
    end
  end

  scope "/twitch", ClientWeb do
    get("/login", TwitchController, :login)
    get("/oauth", TwitchController, :exchange)

    get("/failurelog", TwitchController, :failurelog)
  end
end
