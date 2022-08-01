defmodule Client.StorageTest do
  use Client.DataCase, async: true

  alias Client.{
    Repo,
    Storage
  }

  describe "list_contexts/1" do
    test "lists my contexts" do
      user = insert(:user)
      context = insert(:storage_context, creator: user)
      _not_my_context = insert(:storage_context, creator: insert(:user))

      context_ids = user.id |> Storage.list_contexts() |> Enum.map(& &1.id)

      assert [context.id] == context_ids
    end

    test "list contexts for my teams" do
      me = insert(:user)
      my_team_lead = insert(:user)
      team = insert(:team, users: [me, my_team_lead])
      context = insert(:storage_context, creator: my_team_lead, teams: [team])
      _not_my_context = insert(:storage_context, creator: my_team_lead)

      context_ids = me.id |> Storage.list_contexts() |> Enum.map(& &1.id)

      assert [context.id] == context_ids
    end
  end

  describe "list_items/2" do
    test "lists items for my context" do
      user = insert(:user)
      context = insert(:storage_context, creator: user)
      item = insert(:storage_item, context: context)
      other_context = insert(:storage_context, creator: insert(:user))
      _other_item = insert(:storage_item, context: other_context)

      item_ids = user.id |> Storage.list_items(context.id) |> Enum.map(& &1.id)

      assert item_ids == [item.id]
    end

    test "lists items for my team's context" do
      me = insert(:user)
      team_lead = insert(:user)
      team = insert(:team, users: [me, team_lead])
      context = insert(:storage_context, creator: team_lead, teams: [team])
      item = insert(:storage_item, context: context)

      item_ids = me.id |> Storage.list_items(context.id) |> Enum.map(& &1.id)

      assert item_ids == [item.id]
    end

    test "doesn't list anything if I can't access the context" do
      user = insert(:user)
      context = insert(:storage_context, creator: insert(:user))
      _item = insert(:storage_item, context: context)

      assert Storage.list_items(user.id, context.id) == []
    end
  end

  describe "create_context/1" do
    test "creates a context" do
      user = insert(:user)
      attrs = string_params_for(:storage_context, creator: user)
      assert {:ok, _context} = Storage.create_context(user.id, attrs)
    end

    test "creates a context with a team" do
      user = insert(:user)
      team = insert(:team, users: [user])

      attrs =
        string_params_for(:storage_context,
          creator: user,
          team_names: [team.name]
        )

      {:ok, context} = Storage.create_context(user.id, attrs)
      context = Repo.preload(context, :teams)

      assert Enum.map(context.teams, & &1.id) == [team.id]
    end

    test "doesn't allow me to create for a team to which I don't belong" do
      user = insert(:user)
      not_my_team = insert(:team)

      attrs =
        string_params_for(:storage_context,
          creator: user,
          team_names: [not_my_team.name]
        )

      {:ok, context} = Storage.create_context(user.id, attrs)
      context = Repo.preload(context, :teams)

      assert context.teams == []
    end
  end

  describe "get_context/2" do
    test "returns a context I created" do
      me = insert(:user)
      context = insert(:storage_context, creator: me)

      assert Storage.get_context(me.id, context.id).id == context.id
    end

    test "doesn't return a context that I didn't create" do
      me = insert(:user)
      context = insert(:storage_context, creator: insert(:user))

      refute Storage.get_context(me.id, context.id)
    end

    test "returns a context for a team to which I belong" do
      me = insert(:user)
      my_team_lead = insert(:user)
      team = insert(:team, users: [me, my_team_lead])
      context = insert(:storage_context, creator: my_team_lead, teams: [team])

      assert Storage.get_context(me.id, context.id).id == context.id
    end

    test "doesn't return a context for a team to which I don't belong" do
      me = insert(:user)
      team_lead = insert(:user)
      team = insert(:team, users: [team_lead])
      context = insert(:storage_context, creator: team_lead, teams: [team])

      refute Storage.get_context(me.id, context.id)
    end
  end

  describe "update_context/2" do
    test "updates a context" do
      user = insert(:user)

      context =
        :storage_context
        |> insert(creator: user, name: "before")
        |> Repo.preload(:teams)

      {:ok, context} = Storage.update_context(user.id, context, %{"name" => "after"})

      assert context.name == "after"
    end

    test "can change a context's teams" do
      user = insert(:user)
      [team1, team2] = insert_pair(:team, users: [user])

      context =
        :storage_context
        |> insert(creator: user, name: "before")
        |> Repo.preload(:teams)

      params = %{"team_names" => [team1.name, team2.name]}

      {:ok, context} = Storage.update_context(user.id, context, params)

      context = Repo.preload(context, :teams)
      team_names = Enum.map(context.teams, & &1.name)
      assert team1.name in team_names
      assert team2.name in team_names
    end
  end

  describe "search_items/3" do
    test "searches by names" do
      user = insert(:user)
      context = insert(:storage_context, creator: user)
      value = rand_string()
      item = insert(:storage_item, context: context, name: value)

      ids = user.id |> Storage.search_items(context.id, value) |> Enum.map(& &1.id)

      assert ids == [item.id]
    end

    test "searches by location" do
      user = insert(:user)
      context = insert(:storage_context, creator: user)
      value = rand_string()
      item = insert(:storage_item, context: context, location: value)

      ids = user.id |> Storage.search_items(context.id, value) |> Enum.map(& &1.id)

      assert ids == [item.id]
    end

    test "searches by description" do
      user = insert(:user)
      context = insert(:storage_context, creator: user)
      value = rand_string()
      item = insert(:storage_item, context: context, description: value)

      ids = user.id |> Storage.search_items(context.id, value) |> Enum.map(& &1.id)

      assert ids == [item.id]
    end

    test "orders results by name" do
      user = insert(:user)
      context = insert(:storage_context, creator: user)
      item2 = insert(:storage_item, context: context, name: "test b")
      item1 = insert(:storage_item, context: context, name: "test a")

      ids = user.id |> Storage.search_items(context.id, "test") |> Enum.map(& &1.id)

      assert ids == [item1.id, item2.id]
    end

    test "doesn't return someone else's items" do
      user = insert(:user)
      context = insert(:storage_context, creator: insert(:user))
      _item = insert(:storage_item, context: context, name: "name")

      assert Storage.search_items(user.id, context.id, "name") == []
    end
  end

  describe "create_item/2" do
    test "creates an item" do
      creator = insert(:user)
      context = insert(:storage_context, creator_id: creator.id)
      attrs = params_for(:storage_item, context_id: context.id)

      {:ok, item} = Storage.create_item(context, attrs)

      assert item.location == attrs[:location]
      assert item.name == attrs[:name]
    end

    test "handles name conflicts" do
      creator = insert(:user)
      context = insert(:storage_context, creator_id: creator.id)
      existing = insert(:storage_item, context_id: context.id)
      duplicate_attrs = params_for(:storage_item, context_id: context.id, name: existing.name)

      {:error, changeset} = Storage.create_item(context, duplicate_attrs)

      name_errors = errors_on(changeset)[:name]

      assert name_errors == [
               "This name already exists. Please choose another one."
             ]
    end
  end
end
