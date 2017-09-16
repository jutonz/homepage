defmodule Homepage.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, unique: true
      add :password, :string

      timestamps()
    end

  end
end
