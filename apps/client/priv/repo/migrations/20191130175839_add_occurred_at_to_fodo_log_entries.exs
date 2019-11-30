defmodule Client.Repo.Migrations.AddOccurredAtToFodoLogEntries do
  use Ecto.Migration

  def up do
    alter table(:food_log_entries) do
      add(:occurred_at, :naive_datetime)
    end

    execute("UPDATE food_log_entries SET occurred_at = inserted_at")

    alter table(:food_log_entries) do
      modify(:occurred_at, :naive_datetime, null: false)
    end
  end

  def down do
    alter table(:food_log_entries) do
      remove(:occurred_at)
    end
  end
end
