defmodule Twitch.GoogleRepo.Migrations.CreateChannel do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add(:name, :string)
      add(:user_id, references(:users))

      timestamps()
    end

    create(index(:channels, [:user_id, :name], unique: true))
  end
end
