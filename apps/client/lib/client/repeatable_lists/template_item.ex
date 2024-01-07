defmodule Client.RepeatableLists.TemplateItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias Client.RepeatableLists.{
    Template,
    TemplateSection
  }

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "repeatable_list_template_items" do
    field(:name, :string)
    timestamps()

    belongs_to(:template, Template, type: :binary_id)
    belongs_to(:section, TemplateSection, source: :section_id)
  end

  @optional_fields ~w[]a
  @required_fields ~w[name template_id]a

  def changeset(item, attrs) do
    item
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
