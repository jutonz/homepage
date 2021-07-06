defmodule Auth.Mixfile do
  use Mix.Project

  def project do
    [
      app: :auth,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Auth.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:guardian, "~> 2.0"},
      {:comeonin, "~> 5.1"},
      {:argon2_elixir, "~> 2.0"},
      {:redis, in_umbrella: true}
    ]
  end
end
