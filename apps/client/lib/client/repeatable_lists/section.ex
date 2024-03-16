defmodule Client.RepeatableLists.Section do
  use Ecto.Schema
  import Ecto.Changeset

  alias Client.RepeatableLists.{
    List,
    Item,
    TemplateSection
  }

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "repeatable_list_sections" do
    field(:name, :string)
    timestamps()

    belongs_to(:list, List, type: :binary_id)
    belongs_to(:template_section, TemplateSection, type: :binary_id)
    has_many(:items, Item, foreign_key: :section_id)
  end

  @optional_fields ~w[template_section_id]a
  @required_fields ~w[name list_id]a
  @all_fields @optional_fields ++ @required_fields

  @spec changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset(section, attrs) do
    section
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
