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
end
