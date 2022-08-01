defmodule Client.Storage.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

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
    |> unique_constraint(:name,
      name: :storage_items_context_id_name_index,
      message: "This name already exists. Please choose another one."
    )
  end
end
