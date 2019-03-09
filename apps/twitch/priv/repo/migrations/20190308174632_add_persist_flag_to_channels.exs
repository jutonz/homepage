defmodule Twitch.Repo.Migrations.AddPersistFlagToChannels do
  use Ecto.Migration

  def change do
    alter table("channels") do
      add(:persist, :boolean, default: false)
    end
  end
end
