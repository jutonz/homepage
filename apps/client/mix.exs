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
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
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
      extra_applications: [:bamboo, :logger, :runtime_tools, :redix, :os_mon]
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
      {:absinthe, "~> 1.7"},
      {:absinthe_error_payload, "~> 1.0"},
      {:absinthe_plug, "~> 1.5"},
      {:argon2_elixir, "~> 4.0"},
      {:bamboo, "~> 2.0"},
      {:bamboo_phoenix, "~> 1.0"},
      {:briefly, "~> 0.5.0", only: :test},
      {:comeonin, "~> 5.1"},
      {:cors_plug, "~> 3.0"},
      {:ecto_sql, "~> 3.0"},
      {:events, in_umbrella: true},
      {:ex_machina, "~> 2.2", only: :test},
      {:finch, "~> 0.14"},
      {:floki, "~> 0.38.0", only: :test},
      {:gen_stage, "~> 1.3.0"},
      {:gettext, "~> 0.11"},
      {:guardian, "~> 2.0"},
      {:hackney, "~> 1.8"},
      {:jason, "~> 1.1"},
      {:money, "~> 1.12"},
      {:mox, "~> 1.0", only: :test},
      {:nimble_csv, "~> 1.1"},
      {:phoenix, "1.7.21"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 4.2.0"},
      {:phoenix_html_helpers, "~> 1.0"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_view, "~> 2.0"},
      {:plug_cowboy, "~> 2.3"},
      {:plug_static_index_html, "~> 1.0"},
      {:postgrex, "~> 0.14"},
      {:redis, in_umbrella: true},
      {:req, "~> 0.5.0"},
      {:sentry, "~> 11.0"},
      {:timex, "~> 3.7"},
      {:twitch, in_umbrella: true},
      {:wallaby, "~> 0.30.0", only: :test},
      # Live dashboard
      {:phoenix_live_dashboard, "~> 0.8.0"},
      {:ecto_psql_extras, "~> 0.2"},
      {:telemetry_poller, "~> 0.4"},
      {:telemetry_metrics, "~> 1.0"}
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
