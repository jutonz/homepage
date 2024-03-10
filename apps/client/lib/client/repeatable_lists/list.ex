defmodule Client.RepeatableLists.List do
  use Ecto.Schema
  import Ecto.Changeset

  alias Client.RepeatableLists.{
    Template,
    Section,
    Item
  }

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "repeatable_lists" do
    field(:name, :string)
    field(:description, :string)
    timestamps()

    belongs_to(:template, Template, type: :binary_id)
    has_many(:sections, Section, foreign_key: :list_id)
    has_many(:items, Item, foreign_key: :list_id)
  end

  @optional_fields ~w[description]a
  @required_fields ~w[name template_id]a

  def changeset(list, attrs) do
    list
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
