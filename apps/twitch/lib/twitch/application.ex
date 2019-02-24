defmodule Twitch.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Twitch.Worker.start_link(arg)
      # {Twitch.Worker, arg},
      supervisor(Twitch.Repo, []),
      Twitch.ChannelSubscriptionSupervisor,
      Twitch.EventPersister,
      Twitch.EventParseFailureLogger,
      Twitch.GamblingSubscriber
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    # {:ok, token} = Evented.Twitch.get_token()
    # token = "jmf2uj92pq949300z38v59p56kmjob"
    # state = state |> Map.put(:pass, "oauth:#{token}")
    opts = [strategy: :one_for_one, name: Twitch.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
