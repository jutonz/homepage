defmodule Client.Storage.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "storage_items" do
    belongs_to(:context, Client.Storage.Context)
    field(:name, :string)
    field(:location, :string)
    field(:description, :string)
    field(:unpacked_at, :utc_datetime)
    timestamps(type: :utc_datetime)
  end

  @required_params ~w[context_id name location]a
  @optional_params ~w[description unpacked_at]a
  @params @required_params ++ @optional_params

  def changeset(item, params) do
    item
    |> cast(params, @params)
    |> validate_required(@required_params)
  end
end
