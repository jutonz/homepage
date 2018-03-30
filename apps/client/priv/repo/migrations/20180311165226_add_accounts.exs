defmodule Client.Repo.Migrations.AddAccounts do
  use Ecto.Migration

  def change do
    create table("accounts") do
      add(:name, :string, size: 100)
      timestamps()
    end

    create table("user_accounts", primary_key: false) do
      add(:account_id, references(:accounts))
      add(:user_id, references(:users))
    end

    create(index(:accounts, :name, unique: true))
  end
end
