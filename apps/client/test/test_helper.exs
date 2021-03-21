ExUnit.start()

Application.put_env(:wallaby, :base_url, ClientWeb.Endpoint.url)

{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:wallaby)

#Ecto.Adapters.SQL.Sandbox.mode(Client.Repo, :manual)
