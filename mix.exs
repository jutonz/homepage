defmodule HomepageUmbrella.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixir: "~> 1.16",
      test_coverage: [tool: ExCoveralls],
      aliases: aliases(),
      dialyzer: [
        plt_add_apps: ~w[mix]a,
        plt_core_path: "_plts",
        plt_file: {:no_warn, "_plts/homepage.plt"}
      ],
      releases: [
        homepage: [
          version: "0.1.0",
          applications: [
            client: :permanent,
            events: :permanent,
            redis: :permanent,
            twitch: :permanent
          ]
        ]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:dialyxir, "~> 1.4.1", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.18.0"}
    ]
  end

  def aliases do
    [
      "env.encrypt": "exenv.encrypt /apps/twitch/config/master.key /apps/twitch/config/.env",
      "env.decrypt": "exenv.decrypt /apps/twitch/config/master.key /apps/twitch/config/.env.enc",
      dialyzer: ["dialyzer_pre", "dialyzer"],
      "phx.routes": "phx.routes ClientWeb.Router"
    ]
  end
end
