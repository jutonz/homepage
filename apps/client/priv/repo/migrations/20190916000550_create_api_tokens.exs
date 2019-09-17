defmodule Client.Repo.Migrations.CreateApiTokens do
  use Ecto.Migration

  def change do
    create table(:api_tokens, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:token, :string, null: false)
      add(:description, :string)
      add(:user_id, :bigint, null: false)
      timestamps()
    end

    create(index(:api_tokens, :user_id))
    create(index(:api_tokens, [:user_id, :description], unique: true))
    create(index(:api_tokens, [:user_id, :token], unique: true))
  end
end
