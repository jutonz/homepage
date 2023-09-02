defmodule Client.Application do
  use Application

  @file_renamer_path Application.compile_env!(:client, :file_renamer_path)

  # See https://hexdocs.pm/elixir/Application.html for more information on OTP
  # Applications
  def start(_type, _args) do
    children = [
      Client.Repo,
      {Phoenix.PubSub, name: Client.PubSub},
      ClientWeb.Endpoint,
      Client.TwitchServer,
      ClientWeb.Telemetry,
      {Finch, name: ClientFinch},
      {Client.FileRenamer, path: @file_renamer_path},
      Client.Influx.AwairSubscriber,
      Client.Awair.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html for other strategies and
    # supported options
    opts = [strategy: :one_for_one, name: Client.Supervisor]

    {:ok, _} = Logger.add_backend(Sentry.LoggerBackend)

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration whenever the application
  # is updated.
  def config_change(changed, _new, removed) do
    ClientWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
