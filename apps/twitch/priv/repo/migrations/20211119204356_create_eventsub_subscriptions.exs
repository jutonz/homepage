defmodule Twitch.Repo.Migrations.CreateEventsubSubscriptions do
  use Ecto.Migration

  def change do
    create table(:eventsub_subscriptions) do
      add(:twitch_id, :string)
      timestamps(null: false)
    end

    create(index(:eventsub_subscriptions, :twitch_id, unique: true))

    create table(:twitch_channel_updates) do
      add(:twitch_user_id, :string, null: false)
      add(:title, :string, null: false)
      add(:category_id, :string, null: false)
      add(:category_name, :string, null: false)
      timestamps(null: false)
    end

    create(index(:twitch_channel_updates, :twitch_user_id))
  end
end
