defmodule Client.Mixfile do
  use Mix.Project

  def project do
    [
      app: :client,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Client.Application, []},
      extra_applications: [:bamboo, :logger, :runtime_tools, :redix]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:plug_cowboy, "~> 2.0"},
      {:absinthe_ecto, "~> 0.1"},
      {:absinthe_plug, "~> 1.4"},
      {:cors_plug, "~> 2.0"},
      {:plug_static_index_html, "~> 1.0"},
      {:gen_stage, "~> 1.0.0"},
      {:bamboo, "~> 1.1"},
      {:sentry, "~> 7.0"},
      {:jason, "~> 1.1"},
      # TODO: Switch back to a tag once 0.24 is released
      # (we need custom capabilities to enable javascript on CI)
      {:wallaby, [git: "git@github.com:elixir-wallaby/wallaby.git", ref: "a0753fb", runtime: false, only: :test]},
      {:phoenix_live_view, "~> 0.6"},
      {:ex_machina, "~> 2.2", only: :test},
      {:auth, in_umbrella: true},
      {:redis, in_umbrella: true},
      {:twitch, in_umbrella: true},
      {:events, in_umbrella: true},
      {:emoncms, in_umbrella: true}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
