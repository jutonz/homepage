defmodule Redis.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    redis_url = Application.get_env(:redis, :redis_url)

    children = [
      {Redix, {redis_url, [name: :redix]}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html for other strategies and
    # supported options
    opts = [strategy: :one_for_one, name: Redis.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
