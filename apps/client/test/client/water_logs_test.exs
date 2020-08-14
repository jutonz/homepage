defmodule Client.WaterLogsTest do
  use Client.DataCase, async: true

  alias Client.{
    WaterLogs,
    WaterLogs.Filter
  }

  describe "create_filter/1" do
    test "creates a filter" do
      log_id = Ecto.UUID.generate()
      params = %{"water_log_id" => log_id}

      assert {:ok, %Filter{} = filter} = WaterLogs.create_filter(params)
      assert %Filter{water_log_id: log_id} = filter
    end

    test "returns a changeset on error" do
      assert {:error, %Ecto.Changeset{}} = WaterLogs.create_filter(%{})
    end
  end

  describe "get_filter/1" do
    test "returns a filter" do
      filter_id = insert(:water_log_filter).id

      assert %Filter{id: filter_id} = WaterLogs.get_filter(filter_id)
    end

    test "returns nil if no filter matches" do
      assert is_nil(WaterLogs.get_filter(Ecto.UUID.generate()))
    end
  end

  describe "get_by_user_id/2" do
    test "retuns my log" do
      me = insert(:user)
      my_log = insert(:water_log, user_id: me.id)

      assert WaterLogs.get_by_user_id(me.id, my_log.id).id == my_log.id
    end

    test "doesn't return someone else's log" do
      me = insert(:user)
      not_my_log = insert(:water_log)

      assert WaterLogs.get_by_user_id(me.id, not_my_log.id) == nil
    end
  end

  describe "get_amount_dispensed/1" do
    test "returns 0 if the log has no entries" do
      log = insert(:water_log)

      assert WaterLogs.get_amount_dispensed(log.id) == 0
    end

    test "returns sum of all entries" do
      log = insert(:water_log)
      insert(:water_log_entry, water_log_id: log.id, ml: 1)
      insert(:water_log_entry, water_log_id: log.id, ml: 2)

      assert WaterLogs.get_amount_dispensed(log.id) == 3
    end
  end

  describe "list_filters_by_log_id/1" do
    test "is empty if there are no filters" do
      assert [] = WaterLogs.list_filters_by_log_id(Ecto.UUID.generate())
    end

    test "shows filters for only the given log" do
      log_id = Ecto.UUID.generate()
      my_filter = insert(:water_log_filter, water_log_id: log_id)

      other_log_id = Ecto.UUID.generate()
      _other_filter = insert(:water_log_filter, water_log_id: other_log_id)

      assert [^my_filter] = WaterLogs.list_filters_by_log_id(log_id)
    end
  end

  describe "delete_filter/1" do
    test "deletes a filter" do
      filter_id = insert(:water_log_filter).id

      assert {:ok, filter} = WaterLogs.delete_filter(filter_id)
      assert is_nil(WaterLogs.get_filter(filter_id))
    end
  end
end
