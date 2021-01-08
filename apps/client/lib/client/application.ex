defmodule Client.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html for more information on OTP
  # Applications
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Client.Repo, []),
      supervisor(ClientWeb.Endpoint, []),
      {Phoenix.PubSub, name: Client.PubSub},
      worker(Client.UserServer, [[name: :user_server]]),
      Client.TwitchServer,
      ClientWeb.Telemetry
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
