defmodule Client.Repo.Migrations.AddDefaultLocationToStorageContexts do
  use Ecto.Migration

  def change do
    alter(table(:storage_contexts)) do
      add(:default_location, :string)
    end
  end
end
