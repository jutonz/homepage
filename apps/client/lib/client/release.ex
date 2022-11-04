# Copied from https://hexdocs.pm/phoenix/releases.html
defmodule Client.Release do
  def migrate do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(Client.Repo, &Ecto.Migrator.run(&1, :up, all: true))
  end

  def rollback do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(Client.Repo, &Ecto.Migrator.run(&1, :up, all: true))
  end

  defp load_app do
    Application.load(:client)
  end
end
