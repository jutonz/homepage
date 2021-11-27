Code.put_compiler_option(:warnings_as_errors, true)

ExUnit.start()

Application.put_env(:wallaby, :base_url, ClientWeb.Endpoint.url())
Ecto.Adapters.SQL.Sandbox.mode(Twitch.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:wallaby)
