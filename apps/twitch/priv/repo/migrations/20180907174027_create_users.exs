defmodule Twitch.Repo.Migrations.CreateUsers do
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
  end
end
