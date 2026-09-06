defmodule Client.FoodLogsTest do
  use Client.DataCase, async: true

  alias Client.{
    FoodLogs,
    FoodLogs.Entry,
    FoodLogs.FoodLog
  }

  setup do
    scope = build(:scope)
    %{scope: scope, log: insert(:food_log, owner_id: scope.user.id)}
  end

  describe "new_changeset/1" do
    test "returns an empty changeset" do
      cs = FoodLogs.new_changeset()

      assert %Ecto.Changeset{} = cs
      assert cs.changes == %{}
      assert cs.data == %FoodLog{}
    end
  end

  describe "create/2" do
    test "creates a log owned by the scope", %{scope: scope} do
      params = %{"name" => "breakfast"}

      assert {:ok, log} = FoodLogs.create(scope, params)
      assert log.name == "breakfast"
      assert log.owner_id == scope.user.id
    end

    test "takes the owner from the scope, not the params", %{scope: scope} do
      other = insert(:user)
      params = %{"name" => "breakfast", "owner_id" => other.id}

      assert {:ok, log} = FoodLogs.create(scope, params)
      assert log.owner_id == scope.user.id
    end

    test "returns the changeset when invalid", %{scope: scope} do
      assert {:error, %Ecto.Changeset{}} = FoodLogs.create(scope, %{})
    end
  end

  describe "list/1" do
    test "returns the scope's logs", %{scope: scope, log: log} do
      _other_log = insert(:food_log)

      assert Enum.map(FoodLogs.list(scope), & &1.id) == [log.id]
    end
  end

  describe "get/2" do
    test "returns the scope's log", %{scope: scope, log: log} do
      log_id = log.id

      assert %FoodLog{id: ^log_id} = FoodLogs.get(scope, log_id)
    end

    test "is nil for another user's log", %{scope: scope} do
      other_log = insert(:food_log)

      assert FoodLogs.get(scope, other_log.id) == nil
    end

    test "is nil when the log doesn't exist", %{scope: scope} do
      assert FoodLogs.get(scope, Ecto.UUID.generate()) == nil
    end
  end

  describe "get!/2" do
    test "returns the scope's log", %{scope: scope, log: log} do
      log_id = log.id

      assert %FoodLog{id: ^log_id} = FoodLogs.get!(scope, log_id)
    end

    test "raises for another user's log", %{scope: scope} do
      other_log = insert(:food_log)

      assert_raise Ecto.NoResultsError, fn -> FoodLogs.get!(scope, other_log.id) end
    end
  end

  describe "update/3" do
    test "updates the scope's log", %{scope: scope, log: log} do
      assert {:ok, updated} = FoodLogs.update(scope, log.id, %{"name" => "new name"})
      assert updated.name == "new name"
    end

    test "raises for another user's log", %{scope: scope} do
      other_log = insert(:food_log)

      assert_raise Ecto.NoResultsError, fn ->
        FoodLogs.update(scope, other_log.id, %{"name" => "mine now"})
      end

      assert Repo.get(FoodLog, other_log.id).name == other_log.name
    end
  end

  describe "delete/2" do
    test "deletes the scope's log", %{scope: scope, log: log} do
      assert {:ok, _log} = FoodLogs.delete(scope, log.id)
      refute Repo.get(FoodLog, log.id)
    end

    test "raises for another user's log", %{scope: scope} do
      other_log = insert(:food_log)

      assert_raise Ecto.NoResultsError, fn -> FoodLogs.delete(scope, other_log.id) end
      assert Repo.get(FoodLog, other_log.id)
    end
  end

  describe "create_entry/3" do
    test "creates an entry on the scope's log", %{scope: scope, log: log} do
      params = %{"description" => "toast", "occurred_at" => now()}

      assert {:ok, entry} = FoodLogs.create_entry(scope, log.id, params)
      assert entry.description == "toast"
      assert entry.food_log_id == log.id
    end

    test "records the scope's user as who logged it", %{scope: scope, log: log} do
      params = %{"description" => "toast", "occurred_at" => now(), "user_id" => -1}

      assert {:ok, entry} = FoodLogs.create_entry(scope, log.id, params)
      assert entry.user_id == scope.user.id
    end

    test "raises for another user's log", %{scope: scope} do
      other_log = insert(:food_log)
      params = %{"description" => "toast", "occurred_at" => now()}

      assert_raise Ecto.NoResultsError, fn ->
        FoodLogs.create_entry(scope, other_log.id, params)
      end
    end
  end

  describe "get_entry/2" do
    test "returns an entry in the scope's log", %{scope: scope, log: log} do
      entry_id = insert(:food_log_entry, food_log_id: log.id).id

      assert %Entry{id: ^entry_id} = FoodLogs.get_entry(scope, entry_id)
    end

    test "is nil for an entry in another user's log", %{scope: scope} do
      entry = insert(:food_log_entry, food_log_id: insert(:food_log).id)

      assert FoodLogs.get_entry(scope, entry.id) == nil
    end

    test "ignores the user id the entry was logged with", %{scope: scope} do
      entry =
        insert(:food_log_entry,
          food_log_id: insert(:food_log).id,
          user_id: scope.user.id
        )

      assert FoodLogs.get_entry(scope, entry.id) == nil
    end

    test "is nil when the entry doesn't exist", %{scope: scope} do
      assert FoodLogs.get_entry(scope, Ecto.UUID.generate()) == nil
    end
  end

  describe "get_entries/2" do
    test "returns the asked-for entries in the scope's logs", %{scope: scope, log: log} do
      [one, two] = insert_pair(:food_log_entry, food_log_id: log.id)
      three = insert(:food_log_entry, food_log_id: log.id)

      ids = scope |> FoodLogs.get_entries([one.id, two.id]) |> Enum.map(& &1.id)

      assert one.id in ids
      assert two.id in ids
      refute three.id in ids
    end

    test "skips entries in another user's log", %{scope: scope, log: log} do
      mine = insert(:food_log_entry, food_log_id: log.id)
      theirs = insert(:food_log_entry, food_log_id: insert(:food_log).id)

      ids = scope |> FoodLogs.get_entries([mine.id, theirs.id]) |> Enum.map(& &1.id)

      assert ids == [mine.id]
    end
  end

  describe "list_entries_occurred_between/4" do
    test "returns the log's entries within the range", %{scope: scope, log: log} do
      inside = insert(:food_log_entry, food_log_id: log.id, occurred_at: ~N[2025-03-14 12:00:00])
      _before = insert(:food_log_entry, food_log_id: log.id, occurred_at: ~N[2025-03-13 12:00:00])
      _after = insert(:food_log_entry, food_log_id: log.id, occurred_at: ~N[2025-03-15 12:00:00])

      entries =
        FoodLogs.list_entries_occurred_between(
          scope,
          log.id,
          ~N[2025-03-14 00:00:00],
          ~N[2025-03-14 23:59:59]
        )

      assert Enum.map(entries, & &1.id) == [inside.id]
    end

    test "is empty for another user's log", %{scope: scope} do
      other_log = insert(:food_log)
      insert(:food_log_entry, food_log_id: other_log.id, occurred_at: ~N[2025-03-14 12:00:00])

      entries =
        FoodLogs.list_entries_occurred_between(
          scope,
          other_log.id,
          ~N[2025-03-14 00:00:00],
          ~N[2025-03-14 23:59:59]
        )

      assert entries == []
    end
  end

  describe "update_entry/3" do
    test "updates an entry in the scope's log", %{scope: scope, log: log} do
      entry = insert(:food_log_entry, food_log_id: log.id)

      assert {:ok, updated} = FoodLogs.update_entry(scope, entry.id, %{"description" => "wee"})
      assert updated.description == "wee"
    end

    test "raises for an entry in another user's log", %{scope: scope} do
      entry = insert(:food_log_entry, food_log_id: insert(:food_log).id)

      assert_raise Ecto.NoResultsError, fn ->
        FoodLogs.update_entry(scope, entry.id, %{"description" => "wee"})
      end

      assert Repo.get(Entry, entry.id).description == entry.description
    end

    test "does not let an update move the entry to another log", %{scope: scope, log: log} do
      entry = insert(:food_log_entry, food_log_id: log.id)
      other_log = insert(:food_log)

      assert {:ok, updated} =
               FoodLogs.update_entry(scope, entry.id, %{"food_log_id" => other_log.id})

      assert updated.food_log_id == log.id
    end
  end

  describe "delete_entry/2" do
    test "deletes an entry in the scope's log", %{scope: scope, log: log} do
      entry = insert(:food_log_entry, food_log_id: log.id)

      assert {:ok, _entry} = FoodLogs.delete_entry(scope, entry.id)
      refute Repo.get(Entry, entry.id)
    end

    test "raises for an entry in another user's log", %{scope: scope} do
      entry = insert(:food_log_entry, food_log_id: insert(:food_log).id)

      assert_raise Ecto.NoResultsError, fn -> FoodLogs.delete_entry(scope, entry.id) end
      assert Repo.get(Entry, entry.id)
    end
  end

  defp now, do: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
end
