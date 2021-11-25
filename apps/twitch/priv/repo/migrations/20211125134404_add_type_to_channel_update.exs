defmodule Twitch.Repo.Migrations.AddTypeToChannelUpdate do
  use Ecto.Migration

  def up do
    alter table("twitch_channel_updates") do
      add(:type, :string)
    end

    execute("UPDATE twitch_channel_updates SET type = 'channel.update'")

    alter table("twitch_channel_updates") do
      modify(:type, :string, null: false)
    end
  end

  def down do
    alter table("twitch_channel_updates") do
      remove(:type, :string, null: false)
    end
  end
end
