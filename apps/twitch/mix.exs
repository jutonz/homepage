defmodule Twitch.MixProject do
  use Mix.Project

  def project do
    [
      app: :twitch,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :exenv],
      mod: {Twitch.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.3"},
      {:gen_stage, "~> 1.1.0"},
      {:websockex, "~> 0.4.1"},
      {:exirc, "~> 2.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, "~> 0.14"},
      {:poison, "~> 4.0"},
      {:exenv, "~> 0.3"},
      {:ex_machina, "~> 2.2", only: :test},
      {:events, in_umbrella: true}
    ]
  end
end
