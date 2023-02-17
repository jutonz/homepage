defmodule ClientWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL
      import Wallaby.Feature

      alias Client.Repo
      alias ClientWeb.Router.Helpers, as: Routes

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Client.Factory
      import Wallaby.Query
      import ClientWeb.FeatureHelpers

      @endpoint ClientWeb.Endpoint
    end
  end

  setup _context do
    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Client.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
