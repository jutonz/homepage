defmodule Client.Repo.Migrations.AddAmountProducedToSoapBatches do
  use Ecto.Migration

  def change do
    alter table("soap_batches") do
      add(:amount_produced, :integer)
    end
  end
end
