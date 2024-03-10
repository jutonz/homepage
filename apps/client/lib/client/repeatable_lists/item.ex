defmodule Client.RepeatableLists.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias Client.RepeatableLists.{
    List,
    Section
  }

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "repeatable_list_items" do
    field(:name, :string)
    timestamps()

    belongs_to(:list, List, type: :binary_id)
    belongs_to(:section, Section, type: :binary_id, source: :section_id)
  end

  @optional_fields ~w[section_id]a
  @required_fields ~w[name list_id]a

  def changeset(item, attrs) do
    item
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
