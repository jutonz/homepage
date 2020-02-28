defmodule HomepageUmbrella.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      aliases: aliases(),
      dialyzer: [
        plt_add_apps: ~w[mix]a,
        plt_add_deps: :transitive,
        plt_core_path: "_plts",
        plt_file: {:no_warn, "_plts/homepage.plt"}
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
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.12.0"}
    ]
  end

  def aliases do
    [
      "env.encrypt": "exenv.encrypt /apps/twitch/config/master.key /apps/twitch/config/.env",
      "env.decrypt": "exenv.decrypt /apps/twitch/config/master.key /apps/twitch/config/.env.enc",
      dialyzer: ["dialyzer_pre", "dialyzer"]
    ]
  end
end
