defmodule Twitch.Repo.Migrations.AddConfirmedToWebhookSubscriptions do
  use Ecto.Migration

  def change do
    alter table(:webhook_subscriptions) do
      add(:confirmed, :boolean, default: false)
    end
  end
end
