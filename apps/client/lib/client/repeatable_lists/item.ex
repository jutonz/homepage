defmodule Client.RepeatableLists.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias Client.RepeatableLists.{
    List,
    Section
  }

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "repeatable_list_items" do
    field(:name, :string)
    field(:completed_at, :naive_datetime)
    timestamps()

    belongs_to(:list, List, type: :binary_id)
    belongs_to(:section, Section, type: :binary_id, source: :section_id)
  end

  @optional_fields ~w[section_id completed_at]a
  @required_fields ~w[name list_id]a
  @all_fields @optional_fields ++ @required_fields

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(item, attrs) do
    item
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
