defmodule ClientWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias ClientWeb.Router.Helpers, as: Routes
      import Plug.Conn
      import Phoenix.ConnTest
      import Client.Factory
      import ClientWeb.HtmlHelpers

      @endpoint ClientWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Client.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Client.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
