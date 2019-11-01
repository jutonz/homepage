defmodule Twitch.Repo.Migrations.CreateSubscriptionCallbacks do
  use Ecto.Migration

  def change do
    create table(:webhook_subscriptions_callbacks, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:subscription_id, :uuid, null: false)
      add(:user_id, :string, null: false)
      add(:game_id, :string, null: false)
      add(:body, :jsonb, null: false)
      timestamps()
    end
  end
end
