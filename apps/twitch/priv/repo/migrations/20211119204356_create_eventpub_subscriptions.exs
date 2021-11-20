defmodule Twitch.Repo.Migrations.CreateEventpubSubscriptions do
  use Ecto.Migration

  def change do
    create table(:eventpub_subscriptions) do
      add(:twitch_id, :string)
      timestamps(null: false)
    end

    create index(:eventpub_subscriptions, :twitch_id, unique: true)
  end
end
