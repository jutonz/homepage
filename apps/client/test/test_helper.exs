ExUnit.start()

{:ok, _} = Application.ensure_all_started(:wallaby)

Ecto.Adapters.SQL.Sandbox.mode(Client.Repo, :manual)
