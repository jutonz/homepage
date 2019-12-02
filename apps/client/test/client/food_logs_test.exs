defmodule Client.FoodLogsTest do
  use Client.DataCase, async: true
  alias Client.FoodLogs
  alias Client.FoodLogs.FoodLog

  describe "new_changeset/1" do
    test "returns an empty changeset" do
      cs = FoodLogs.new_changeset()

      assert %Ecto.Changeset{} = cs
      assert cs.changes == %{}
      assert cs.data == %FoodLog{}
    end
  end

  describe "create/1" do
    test "it creates a food log" do
      params = %{
        name: "test",
        owner_id: "123"
      }

      assert {:ok, log} = FoodLogs.create(params)
    end
  end

  describe "create_entry/1" do
    test "it creates an entry" do
      params = params_for(:food_log_entry)

      assert {:ok, _entry} = FoodLogs.create_entry(params)
    end
  end

  describe "get/1" do
    test "returns a food log if it exists" do
      log_id = insert(:food_log).id

      assert %FoodLog{id: log_id} = FoodLogs.get(log_id)
    end

    test "returns nil if the food log doesn't exist" do
      assert nil == FoodLogs.get(Ecto.UUID.generate())
    end
  end

  describe "list_by_owner_id/1" do
    test "returns logs by the owner" do
      my_id = "123"
      my_log = insert(:food_log, owner_id: my_id)
      _other_log = insert(:food_log)

      assert FoodLogs.list_by_owner_id(my_id) == [my_log]
    end
  end

  describe "list_entries_by_day/1" do
    test "returns entries grouped by day" do
      log = insert(:food_log)
      today = DateTime.add(DateTime.utc_now(), -60, :second)
      today_entry = insert(:food_log_entry, food_log_id: log.id, occurred_at: today)
      yesterday = DateTime.add(DateTime.utc_now(), -60 * 60 * 24, :second)
      yesterday_entry = insert(:food_log_entry, food_log_id: log.id, occurred_at: yesterday)

      entries = FoodLogs.list_entries_by_day(log.id)

      assert entries[occurred_at(today_entry)] == [today_entry.description]

      assert entries[occurred_at(yesterday_entry)] == [
               yesterday_entry.description
             ]
    end

    test "returns entries for the given log" do
      log = insert(:food_log)
      entry = insert(:food_log_entry, food_log_id: log.id)
      other_log = insert(:food_log)
      _other_entry = insert(:food_log_entry, food_log_id: other_log.id)

      entries = FoodLogs.list_entries_by_day(log.id)

      assert entries[Ecto.Date.cast!(entry.occurred_at)] == [entry.description]
    end
  end

  describe "delete/1" do
    test "deletes the log by its id" do
      log = insert(:food_log)

      assert {:ok, log} = FoodLogs.delete(log.id)
      refute Client.Repo.get(FoodLog, log.id)
    end
  end

  defp occurred_at(log_entry),
    do: Ecto.Date.cast!(log_entry.occurred_at)
end
