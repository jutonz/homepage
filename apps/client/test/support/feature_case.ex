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

  @headless Application.compile_env(:wallaby, :chromedriver)[:headless]

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
          # Enable software rendering using SwANGLE. When using --headless, we
          # don't get a GPU, but WebGL stuff (Three.js) needs one. I found I
          # needed this flag to get Three.js animations to work in tests on my
          # machine. Interestingly, this didn't seem necessary for CI. Maybe
          # something changed in recent chrome versions?
          # https://stackoverflow.com/a/73048626
          args = ["--use-gl=angle" | args]
          args = ["--window-size=1920,1080" | args]

          args =
            if @headless do
              ["--headless" | args]
            else
              args
            end

          capabilities = put_in(capabilities, [:chromeOptions, :args], args)
          Wallaby.WebdriverClient.create_session(url, capabilities)
        end
      )

    {:ok, session: session}
  end
end
