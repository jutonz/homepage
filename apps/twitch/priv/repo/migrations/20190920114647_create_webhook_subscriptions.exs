defmodule Twitch.Repo.Migrations.CreateWebhookSubscriptions do
  use Ecto.Migration

  def change do
    create table(:webhook_subscriptions, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:topic, :string, null: false)
      add(:secret, :string, null: false)
      add(:expires_at, :naive_datetime, null: false)
      add(:user_id, :bigint, null: false)
      timestamps()
    end

    create(
      index(
        :webhook_subscriptions,
        [:user_id, :topic],
        unique: true
      )
    )
  end
end
