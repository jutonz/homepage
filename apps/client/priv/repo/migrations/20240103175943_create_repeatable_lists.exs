defmodule Client.Repo.Migrations.CreateRepeatableLists do
  use Ecto.Migration

  def change do
    create table(:repeatable_list_templates, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:description, :string)
      add(:owner_id, references("users", on_delete: :delete_all), null: false)
      timestamps(type: :utc_datetime)
    end

    create table(:repeatable_list_template_sections, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:template_id, references("repeatable_list_templates", on_delete: :delete_all, type: :uuid), null: false)
      timestamps(type: :utc_datetime)
    end

    create table(:repeatable_list_template_items, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:template_id, references("repeatable_list_templates", on_delete: :delete_all, type: :uuid), null: false)
      add(:section_id, references("repeatable_list_template_sections", on_delete: :delete_all, type: :uuid), null: true)
      timestamps(type: :utc_datetime)
    end

    create table(:repeatable_lists, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:description, :string)
      add(:template_id, references("repeatable_list_templates", on_delete: :delete_all, type: :uuid), null: false)
      timestamps(type: :utc_datetime)
    end

    create table(:repeatable_list_sections, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:list_id, references("repeatable_lists", on_delete: :delete_all, type: :uuid), null: false)
      timestamps(type: :utc_datetime)
    end

    create table(:repeatable_list_items, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:completed_at, :utc_datetime)
      add(:list_id, references("repeatable_lists", on_delete: :delete_all, type: :uuid), null: false)
      add(:section_id, references("repeatable_list_sections", on_delete: :delete_all, type: :uuid), null: true)
      timestamps(type: :utc_datetime)
    end
  end
end
