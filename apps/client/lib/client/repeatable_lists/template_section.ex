defmodule Client.RepeatableLists.TemplateSection do
  use Ecto.Schema
  alias Client.RepeatableLists.{
    Template,
    TemplateItem
  }

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "repeatable_list_template_sections" do
    field(:name, :string)
    timestamps()

    belongs_to(:template, Template)
    has_many(:items, TemplateItem)
  end
end
