defmodule Client.RepeatableLists.TemplateItem do
  use Ecto.Schema
  alias Client.RepeatableLists.{
    Template,
    TemplateSection
  }

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "repeatable_list_template_items" do
    field(:name, :string)
    timestamps()

    belongs_to(:template, Template)
    belongs_to(:section, TemplateSection)
  end
end
