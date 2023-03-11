if System.get_env("CI") do
  Code.put_compiler_option(:warnings_as_errors, true)
end

Application.put_env(:wallaby, :base_url, ClientWeb.Endpoint.url())

{:ok, _} = Application.ensure_all_started(:mox)
{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:wallaby)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Client.Repo, :manual)
Ecto.Adapters.SQL.Sandbox.mode(Twitch.Repo, :manual)
