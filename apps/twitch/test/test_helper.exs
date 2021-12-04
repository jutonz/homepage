if System.get_env("CI") do
  Code.put_compiler_option(:warnings_as_errors, true)
end

{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:mox)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Twitch.Repo, :manual)
