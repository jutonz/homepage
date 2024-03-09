defmodule Client.RepeatableListsTest do
  use Client.DataCase, async: true
  alias Client.RepeatableLists

  describe ".create_list_from_template/1" do
    test "copies the template name and desc" do
      user = insert(:user)

      template =
        insert(
          :repeatable_list_template,
          owner: user,
          name: "name!",
          description: "description!"
        )

      {:ok, list} = RepeatableLists.create_list_from_template(template)

      assert list
      assert list.name == template.name
      assert list.description == template.description
    end

    test "copies items" do
      user = insert(:user)
      template = insert(:repeatable_list_template, owner: user)

      template_item1 =
        insert(
          :repeatable_list_template_item,
          template: template,
          name: "item 1 name!"
        )

      template_item2 =
        insert(
          :repeatable_list_template_item,
          template: template,
          name: "item 2 name!"
        )

      {:ok, list} = RepeatableLists.create_list_from_template(template)
      list = Repo.preload(list, :items)

      assert [item1, item2] = list.items
      assert item1.name == template_item1.name
      assert item2.name == template_item2.name
    end

    test "copies sections" do
      user = insert(:user)
      template = insert(:repeatable_list_template, owner: user)

      template_section1 =
        insert(
          :repeatable_list_template_section,
          template: template,
          name: "section 1 name!"
        )

      template_section2 =
        insert(
          :repeatable_list_template_section,
          template: template,
          name: "section 2 name!"
        )

      {:ok, list} = RepeatableLists.create_list_from_template(template)
      list = Repo.preload(list, :sections)

      assert [section1, section2] = list.sections
      assert section1.name == template_section1.name
      assert section2.name == template_section2.name
    end
  end
end
