defmodule Client.RepeatableLists.Template do
  use Ecto.Schema
  import Ecto.Changeset

  alias Client.RepeatableLists.{
    TemplateSection,
    TemplateItem
  }

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "repeatable_list_templates" do
    field(:name, :string)
    field(:description, :string)
    timestamps()

    belongs_to(:owner, Client.User)
    has_many(:sections, TemplateSection)
    has_many(:items, TemplateItem, foreign_key: :template_id)
  end

  @optional_fields ~w[description]a
  @required_fields ~w[name owner_id]a

  def changeset(template, attrs) do
    template
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
