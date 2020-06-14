defmodule ClientWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias Client.Repo
      alias ClientWeb.Router.Helpers, as: Routes

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Client.Factory
      import ClientWeb.FeatureHelpers

      Application.put_env(:wallaby, :base_url, ClientWeb.Endpoint.url())

      @endpoint ClientWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Client.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Client.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Client.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
