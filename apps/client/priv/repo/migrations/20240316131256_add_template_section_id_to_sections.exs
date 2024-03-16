defmodule Client.Repo.Migrations.AddTemplateSectionIdToSections do
  use Ecto.Migration

  def change do
    alter table("repeatable_list_sections") do
      add(
        :template_section_id,
        references("repeatable_list_template_sections", type: :uuid)
      )
    end
  end
end
