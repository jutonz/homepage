defmodule Twitch.Repo.Migrations.CreateUsersAndChannels do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string)
      add(:display_name, :string)
      add(:access_token, :map)
      add(:user_id, :string)
      add(:twitch_user_id, :string)

      timestamps()
    end

    create(index(:users, :twitch_user_id, unique: true))

    create table(:channels) do
      add(:name, :string)
      add(:user_id, references(:users))
      add(:persist, :boolean, default: false)

      timestamps()
    end

    create(index(:channels, [:user_id, :name], unique: true))
  end
end
