defmodule Client.RepeatableLists.TemplateSection do
  use Ecto.Schema
  import Ecto.Changeset

  alias Client.RepeatableLists.{
    Template,
    TemplateItem
  }

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "repeatable_list_template_sections" do
    field(:name, :string)
    timestamps()

    belongs_to(:template, Template, type: :binary_id)
    has_many(:items, TemplateItem, foreign_key: :section_id)
  end

  @optional_fields ~w[]a
  @required_fields ~w[name template_id]a

  @spec changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset(section, attrs) do
    section
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
