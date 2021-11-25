defmodule Twitch.Repo.Migrations.AddMoreInfoToEventsubSubscriptions do
  use Ecto.Migration

  def up do
    alter table("eventsub_subscriptions") do
      add(:type, :string)
      add(:version, :integer)
      add(:condition, :map, default: %{})
    end

    flush()

    execute("""
    UPDATE eventsub_subscriptions
    SET type = 'channel.update',
        version = 1,
        condition = '{"broadcaster_user_id": "26921830"}'
    """)

    alter table("eventsub_subscriptions") do
      modify(:type, :string, null: false)
      modify(:version, :integer, null: false)
      modify(:condition, :map, null: false)
    end
  end

  def down do
    alter table("eventsub_subscriptions") do
      remove(:type)
      remove(:version)
      remove(:condition)
    end
  end
end
