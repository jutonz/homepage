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
    has_many(:items, TemplateItem)
  end

  @optional_fields ~w[name]a
  @required_fields ~w[description]a

  def changeset(template, attrs) do
    template
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
