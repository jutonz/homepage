defmodule Client.Repo.Migrations.CreateTwitchEvent do
  use Ecto.Migration

  def change do
    create table(:twitch_events) do
      add(:channel, :string)
      add(:message, :string)
      add(:display_name, :string)
      add(:raw_event, :text)

      timestamps()
    end
  end
end
