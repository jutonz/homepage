{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:mox)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Twitch.Repo, :manual)
