defmodule Client.WaterLogsTest do
  use Client.DataCase, async: true

  alias Client.WaterLogs
  alias Client.WaterLogs.Entry
  alias Client.WaterLogs.Filter
  alias Client.WaterLogs.WaterLog

  setup do
    scope = build(:scope)
    %{scope: scope, log: insert(:water_log, user_id: scope.user.id)}
  end

  describe "new_changeset/0" do
    test "returns an empty changeset" do
      cs = WaterLogs.new_changeset()

      assert %Ecto.Changeset{} = cs
      assert cs.changes == %{}
      assert cs.data == %WaterLog{}
    end
  end

  describe "create/2" do
    test "creates a log owned by the scope", %{scope: scope} do
      assert {:ok, log} = WaterLogs.create(scope, %{"name" => "kitchen"})
      assert log.name == "kitchen"
      assert log.user_id == scope.user.id
    end

    test "takes the owner from the scope, not the params", %{scope: scope} do
      other = insert(:user)
      params = %{"name" => "kitchen", "user_id" => other.id}

      assert {:ok, log} = WaterLogs.create(scope, params)
      assert log.user_id == scope.user.id
    end

    test "returns the changeset when invalid", %{scope: scope} do
      assert {:error, %Ecto.Changeset{}} = WaterLogs.create(scope, %{})
    end
  end

  describe "list/1" do
    test "returns the scope's logs", %{scope: scope, log: log} do
      _other_log = insert(:water_log)

      assert Enum.map(WaterLogs.list(scope), & &1.id) == [log.id]
    end
  end

  describe "get/2" do
    test "returns the scope's log", %{scope: scope, log: log} do
      log_id = log.id

      assert %WaterLog{id: ^log_id} = WaterLogs.get(scope, log_id)
    end

    test "is nil for another user's log", %{scope: scope} do
      other_log = insert(:water_log)

      assert WaterLogs.get(scope, other_log.id) == nil
    end

    test "is nil when the log doesn't exist", %{scope: scope} do
      assert WaterLogs.get(scope, Ecto.UUID.generate()) == nil
    end
  end

  describe "get!/2" do
    test "returns the scope's log", %{scope: scope, log: log} do
      log_id = log.id

      assert %WaterLog{id: ^log_id} = WaterLogs.get!(scope, log_id)
    end

    test "raises for another user's log", %{scope: scope} do
      other_log = insert(:water_log)

      assert_raise Ecto.NoResultsError, fn -> WaterLogs.get!(scope, other_log.id) end
    end
  end

  describe "create_entry/3" do
    test "creates an entry in the scope's log", %{scope: scope, log: log} do
      assert {:ok, %Entry{} = entry} = WaterLogs.create_entry(scope, log.id, %{"ml" => 100})
      assert entry.ml == 100
      assert entry.water_log_id == log.id
      assert entry.user_id == scope.user.id
    end

    test "takes the owner from the scope, not the params", %{scope: scope, log: log} do
      other = insert(:user)
      params = %{"ml" => 100, "user_id" => other.id}

      assert {:ok, entry} = WaterLogs.create_entry(scope, log.id, params)
      assert entry.user_id == scope.user.id
    end

    test "raises for another user's log", %{scope: scope} do
      other_log = insert(:water_log)

      assert_raise Ecto.NoResultsError, fn ->
        WaterLogs.create_entry(scope, other_log.id, %{"ml" => 100})
      end
    end

    test "returns the changeset when invalid", %{scope: scope, log: log} do
      assert {:error, %Ecto.Changeset{}} = WaterLogs.create_entry(scope, log.id, %{})
    end
  end

  describe "list_entries/2" do
    test "returns the log's entries, newest first", %{scope: scope, log: log} do
      yesterday = DateTime.utc_now() |> DateTime.shift(day: -1)
      old = insert(:water_log_entry, water_log_id: log.id, inserted_at: yesterday)
      new = insert(:water_log_entry, water_log_id: log.id)

      assert Enum.map(WaterLogs.list_entries(scope, log.id), & &1.id) == [new.id, old.id]
    end

    test "is empty for another user's log", %{scope: scope} do
      other_log = insert(:water_log)
      insert(:water_log_entry, water_log_id: other_log.id)

      assert WaterLogs.list_entries(scope, other_log.id) == []
    end
  end

  describe "create_filter/3" do
    test "creates a filter on the scope's log", %{scope: scope, log: log} do
      log_id = log.id

      assert {:ok, %Filter{} = filter} =
               WaterLogs.create_filter(scope, log_id, %{"lifespan" => 2000})

      assert %Filter{water_log_id: ^log_id, lifespan: 2000} = filter
    end

    test "takes the log from the argument, not the params", %{scope: scope, log: log} do
      other_log = insert(:water_log)
      params = %{"lifespan" => 2000, "water_log_id" => other_log.id}

      assert {:ok, filter} = WaterLogs.create_filter(scope, log.id, params)
      assert filter.water_log_id == log.id
    end

    test "raises for another user's log", %{scope: scope} do
      other_log = insert(:water_log)

      assert_raise Ecto.NoResultsError, fn ->
        WaterLogs.create_filter(scope, other_log.id, %{"lifespan" => 2000})
      end
    end

    test "returns a changeset on error", %{scope: scope, log: log} do
      assert {:error, %Ecto.Changeset{}} =
               WaterLogs.create_filter(scope, log.id, %{"lifespan" => -1})
    end
  end

  describe "get_filter/3" do
    test "returns a filter on the scope's log", %{scope: scope, log: log} do
      filter_id = insert(:water_log_filter, water_log_id: log.id).id

      assert %Filter{id: ^filter_id} = WaterLogs.get_filter(scope, log.id, filter_id)
    end

    test "is nil for another user's filter", %{scope: scope} do
      other_filter = insert(:water_log_filter)

      assert WaterLogs.get_filter(scope, other_filter.water_log_id, other_filter.id) == nil
    end

    test "is nil for a filter on a different log", %{scope: scope, log: log} do
      filter = insert(:water_log_filter, water_log_id: log.id)
      other_log = insert(:water_log, user_id: scope.user.id)

      assert WaterLogs.get_filter(scope, other_log.id, filter.id) == nil
    end

    test "is nil if no filter matches", %{scope: scope, log: log} do
      assert is_nil(WaterLogs.get_filter(scope, log.id, Ecto.UUID.generate()))
    end
  end

  describe "get_filter!/3" do
    test "returns a filter on the scope's log", %{scope: scope, log: log} do
      filter_id = insert(:water_log_filter, water_log_id: log.id).id

      assert %Filter{id: ^filter_id} = WaterLogs.get_filter!(scope, log.id, filter_id)
    end

    test "raises for another user's filter", %{scope: scope} do
      other_filter = insert(:water_log_filter)

      assert_raise Ecto.NoResultsError, fn ->
        WaterLogs.get_filter!(scope, other_filter.water_log_id, other_filter.id)
      end
    end

    test "raises for a filter on a different log", %{scope: scope, log: log} do
      filter = insert(:water_log_filter, water_log_id: log.id)
      other_log = insert(:water_log, user_id: scope.user.id)

      assert_raise Ecto.NoResultsError, fn ->
        WaterLogs.get_filter!(scope, other_log.id, filter.id)
      end
    end
  end

  describe "get_current_filter/2" do
    test "returns the latest filter", %{scope: scope, log: log} do
      yesterday = DateTime.utc_now() |> DateTime.shift(day: -1)
      _old_filter = insert(:water_log_filter, water_log_id: log.id, inserted_at: yesterday)
      new_filter = insert(:water_log_filter, water_log_id: log.id)

      assert WaterLogs.get_current_filter(scope, log.id) == new_filter
    end

    test "is nil for another user's log", %{scope: scope} do
      other_log = insert(:water_log)
      insert(:water_log_filter, water_log_id: other_log.id)

      assert WaterLogs.get_current_filter(scope, other_log.id) == nil
    end
  end

  describe "list_filters/2" do
    test "is empty if there are no filters", %{scope: scope, log: log} do
      assert [] = WaterLogs.list_filters(scope, log.id)
    end

    test "shows filters for only the given log", %{scope: scope, log: log} do
      my_filter = insert(:water_log_filter, water_log_id: log.id)

      other_log = insert(:water_log, user_id: scope.user.id)
      _other_filter = insert(:water_log_filter, water_log_id: other_log.id)

      assert [^my_filter] = WaterLogs.list_filters(scope, log.id)
    end

    test "is empty for another user's log", %{scope: scope} do
      other_log = insert(:water_log)
      insert(:water_log_filter, water_log_id: other_log.id)

      assert WaterLogs.list_filters(scope, other_log.id) == []
    end
  end

  describe "update_filter/4" do
    test "updates a filter on the scope's log", %{scope: scope, log: log} do
      filter = insert(:water_log_filter, water_log_id: log.id, lifespan: 1000)

      assert {:ok, updated} =
               WaterLogs.update_filter(scope, log.id, filter.id, %{"lifespan" => 2000})

      assert updated.lifespan == 2000
    end

    test "cannot move a filter onto another log", %{scope: scope, log: log} do
      filter = insert(:water_log_filter, water_log_id: log.id)
      other_log = insert(:water_log)

      params = %{"lifespan" => 2000, "water_log_id" => other_log.id}

      assert {:ok, updated} = WaterLogs.update_filter(scope, log.id, filter.id, params)
      assert updated.water_log_id == log.id
    end

    test "raises for another user's filter", %{scope: scope} do
      other_filter = insert(:water_log_filter)

      assert_raise Ecto.NoResultsError, fn ->
        WaterLogs.update_filter(scope, other_filter.water_log_id, other_filter.id, %{
          "lifespan" => 2000
        })
      end
    end

    test "raises when the filter is on a different log", %{scope: scope, log: log} do
      filter = insert(:water_log_filter, water_log_id: log.id, lifespan: 1000)
      other_log = insert(:water_log, user_id: scope.user.id)

      assert_raise Ecto.NoResultsError, fn ->
        WaterLogs.update_filter(scope, other_log.id, filter.id, %{"lifespan" => 2000})
      end

      assert Repo.get!(Filter, filter.id).lifespan == 1000
    end
  end

  describe "delete_filter/3" do
    test "deletes a filter on the scope's log", %{scope: scope, log: log} do
      filter_id = insert(:water_log_filter, water_log_id: log.id).id

      assert {:ok, _filter} = WaterLogs.delete_filter(scope, log.id, filter_id)
      assert is_nil(WaterLogs.get_filter(scope, log.id, filter_id))
    end

    test "raises for another user's filter", %{scope: scope} do
      other_filter = insert(:water_log_filter)

      assert_raise Ecto.NoResultsError, fn ->
        WaterLogs.delete_filter(scope, other_filter.water_log_id, other_filter.id)
      end

      assert Repo.get(Filter, other_filter.id)
    end

    test "raises when the filter is on a different log", %{scope: scope, log: log} do
      filter = insert(:water_log_filter, water_log_id: log.id)
      other_log = insert(:water_log, user_id: scope.user.id)

      assert_raise Ecto.NoResultsError, fn ->
        WaterLogs.delete_filter(scope, other_log.id, filter.id)
      end

      assert Repo.get(Filter, filter.id)
    end
  end
end
