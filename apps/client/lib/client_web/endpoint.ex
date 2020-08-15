defmodule ClientWeb.Endpoint do
  use Sentry.PlugCapture
  use Phoenix.Endpoint, otp_app: :client

  @session_opts [
    store: :cookie,
    key: "_homepage_key",
    signing_salt: "bj3dUFRB"
  ]

  socket("/socket", ClientWeb.UserSocket)
  socket("/twitchsocket", ClientWeb.TwitchSocket)

  socket(
    "/live",
    Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_opts]]
  )

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest when
  # deploying your static files in production.
  plug(Plug.Static.IndexHtml, at: "/")

  plug(
    Plug.Static,
    at: "/",
    from: :client,
    gzip: false
  )

  # Code reloading can be explicitly enabled under the :code_reloader
  # configuration of your endpoint.
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison,
    body_reader: {ClientWeb.CacheBodyReader, :read_body, []}
  )

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
