defmodule Twitch.Repo.Migrations.MakeChannelUpdateAttrsOptional do
  use Ecto.Migration

  def up do
    alter table("twitch_channel_updates") do
      modify(:title, :string, null: true)
      modify(:category_id, :string, null: true)
      modify(:category_name, :string, null: true)
    end
  end

  def down do
    alter table("twitch_channel_updates") do
      modify(:title, :string, null: false)
      modify(:category_id, :string, null: false)
      modify(:category_name, :string, null: false)
    end
  end
end
