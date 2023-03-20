defmodule ClientWeb.Endpoint do
  use Sentry.PlugCapture
  use Phoenix.Endpoint, otp_app: :client

  @session_opts [
    store: :cookie,
    key: "_homepage_key",
    signing_salt: "bj3dUFRB"
  ]

  if sandbox = Application.compile_env(:client, :sql_sandbox) do
    plug(Phoenix.Ecto.SQL.Sandbox,
      at: "/sandbox",
      repo: Client.Repo,
      timeout: 15_000,
      sandbox: sandbox
      # header: "x-beam-metadata",
    )

    # plug(Phoenix.Ecto.SQL.Sandbox, sandbox: sandbox)
  end

  socket("/socket", ClientWeb.UserSocket)
  socket("/twitchsocket", ClientWeb.TwitchSocket)

  socket(
    "/live",
    Phoenix.LiveView.Socket,
    websocket: [connect_info: [:user_agent, session: @session_opts]]
  )

  plug(
    Plug.Static,
    at: "/",
    from: :client,
    gzip: false,
    only: static_paths()
  )

  # Code reloading can be explicitly enabled under the :code_reloader
  # configuration of your endpoint.
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  plug(
    Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"
  )

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison,
    body_reader: {ClientWeb.CacheBodyReader, :read_body, []}
  )

  if Mix.env() == :test do
    plug(ClientWeb.Plugs.FactoryPlug,
      at: "/factory",
      factory: Client.Factory,
      repo: Client.Repo
    )
  end

  plug(Sentry.PlugContext)

  plug(CORSPlug, origin: ["http://localhost:4001"])
  plug(Plug.MethodOverride)
  plug(Plug.Head)

  # The session will be stored in the cookie and signed, this means its
  # contents can be read but not tampered with.  Set :encryption_salt if you
  # would also like to encrypt it.
  plug(Plug.Session, @session_opts)

  plug(ClientWeb.Router)
end
