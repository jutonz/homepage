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

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Client.Repo)
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Twitch.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Client.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for([Client.Repo, Twitch.Repo], self())

    # TODO: Consider using Phoenix.Ecto.SQL.Sandbox.encode_metadata to add sandbox metadata
    # to the user agent string. This way, we wouldn't need to use create_session_fn below,
    # and we could just construct the capabilities completley on our own.

    {:ok, session} =
      Wallaby.start_session(
        metadata: metadata,
        create_session_fn: fn url, capabilities ->
          args = capabilities.chromeOptions.args
          args = Enum.filter(args, fn arg -> String.contains?(arg, "user-agent") end)
          args = ["--use-gl=angle" | args]
          args = ["--window-size=1920,1080" | args]
          capabilities = put_in(capabilities, [:chromeOptions, :args], args)
          IO.puts("Requesting capabilities: #{inspect(capabilities)}")
          Wallaby.WebdriverClient.create_session(url, capabilities)
        end
      )

    require IEx
    IEx.pry()

    {:ok, session: session}
  end
end
