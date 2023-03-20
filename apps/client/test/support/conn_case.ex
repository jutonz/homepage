defmodule ClientWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ClientWeb, :verified_routes

      alias ClientWeb.Router.Helpers, as: Routes
      import Plug.Conn
      import Phoenix.ConnTest
      import Client.Factory
      import ClientWeb.HtmlHelpers

      @endpoint ClientWeb.Endpoint
    end
  end

  setup _tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Twitch.Repo)
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Client.Repo)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
