defmodule Twitch.GoogleRepo.Migrations.CreateGamblingEvents do
  use Ecto.Migration

  def change do
    create table("gambling_events") do
      add(:channel, :string, null: false)
      add(:gamble_type, :string, null: false)
      add(:won, :boolean)
      add(:twitch_event_id, references(:twitch_events, null: false))
      timestamps()
    end
  end
end
