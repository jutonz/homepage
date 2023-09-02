defmodule Client.Awair.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    Supervisor.init(children(), strategy: :one_for_one)
  end

  @config_servers Application.compile_env!(:client, :awair)[:servers]
  defp children do
    Enum.map(@config_servers, fn server ->
      Supervisor.child_spec(
        {Client.Awair.Monitor, server},
        id: String.to_atom("awair_#{server[:name]}")
      )
    end)
  end
end
