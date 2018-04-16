defmodule Client.Repo.Migrations.CascadeDeleteIjustStuff do
  use Ecto.Migration

  def up do
    drop(constraint(:ijust_events, "ijust_events_ijust_context_id_fkey"))
    drop(constraint(:ijust_occurrences, "ijust_occurrences_ijust_event_id_fkey"))

    alter table("ijust_events") do
      modify(:ijust_context_id, references(:ijust_contexts, on_delete: :delete_all))
    end

    alter table("ijust_occurrences") do
      modify(:ijust_event_id, references(:ijust_events, on_delete: :delete_all))
    end
  end

  def down do
    drop(constraint(:ijust_events, "ijust_events_ijust_context_id_fkey"))
    drop(constraint(:ijust_occurrences, "ijust_occurrences_ijust_event_id_fkey"))

    alter table("ijust_events") do
      modify(:ijust_context_id, references(:ijust_contexts))
    end

    alter table("ijust_occurrences") do
      modify(:ijust_event_id, references(:ijust_events))
    end
  end
end
