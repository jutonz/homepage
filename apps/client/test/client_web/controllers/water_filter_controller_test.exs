defmodule ClientWeb.WaterFilterControllerTest do
  use ClientWeb.ConnCase, async: true

  alias Client.Repo
  alias Client.WaterLogs.Filter

  setup do
    user = insert(:user)
    log = insert(:water_log, user_id: user.id)
    %{user: user, log: log, filter: insert(:water_log_filter, water_log_id: log.id)}
  end

  describe "index/2" do
    test "lists the log's filters", %{conn: conn, user: user, log: log, filter: filter} do
      html =
        conn
        |> get(~p"/water-logs/#{log.id}/filters?as=#{user.id}")
        |> html_response(200)

      assert html =~ "water-filter-row-#{filter.id}"
    end

    test "is not found for another user's log", %{conn: conn, user: user} do
      other_log = insert(:water_log)

      assert_error_sent(404, fn ->
        get(conn, ~p"/water-logs/#{other_log.id}/filters?as=#{user.id}")
      end)
    end
  end

  describe "new/2" do
    test "is not found for another user's log", %{conn: conn, user: user} do
      other_log = insert(:water_log)

      assert_error_sent(404, fn ->
        get(conn, ~p"/water-logs/#{other_log.id}/filters/new?as=#{user.id}")
      end)
    end
  end

  describe "create/2" do
    test "creates a filter on the user's log", %{conn: conn, user: user, log: log} do
      conn =
        post(conn, ~p"/water-logs/#{log.id}/filters?as=#{user.id}",
          filter: %{"lifespan" => "2000"}
        )

      assert redirected_to(conn) == ~p"/water-logs/#{log.id}/filters"
      assert Repo.get_by!(Filter, lifespan: 2000).water_log_id == log.id
    end

    test "is not found for another user's log", %{conn: conn, user: user} do
      other_log = insert(:water_log)

      assert_error_sent(404, fn ->
        post(conn, ~p"/water-logs/#{other_log.id}/filters?as=#{user.id}",
          filter: %{"lifespan" => "2000"}
        )
      end)
    end
  end

  describe "edit/2" do
    test "renders the user's filter", %{conn: conn, user: user, log: log, filter: filter} do
      html =
        conn
        |> get(~p"/water-logs/#{log.id}/filters/#{filter.id}/edit?as=#{user.id}")
        |> html_response(200)

      assert html =~ "water-filter-lifespan-input"
    end

    test "is not found for another user's filter", %{conn: conn, user: user} do
      other_filter = insert(:water_log_filter)

      assert_error_sent(404, fn ->
        get(
          conn,
          ~p"/water-logs/#{other_filter.water_log_id}/filters/#{other_filter.id}/edit?as=#{user.id}"
        )
      end)
    end
  end

  describe "edit/2 under a log the filter is not on" do
    test "is not found", %{conn: conn, user: user, filter: filter} do
      other_log = insert(:water_log, user_id: user.id)

      assert_error_sent(404, fn ->
        get(conn, ~p"/water-logs/#{other_log.id}/filters/#{filter.id}/edit?as=#{user.id}")
      end)
    end
  end

  describe "update/2" do
    test "updates the user's filter", %{conn: conn, user: user, log: log, filter: filter} do
      conn =
        put(conn, ~p"/water-logs/#{log.id}/filters/#{filter.id}?as=#{user.id}",
          filter: %{"lifespan" => "3000"}
        )

      assert redirected_to(conn) == ~p"/water-logs/#{log.id}/filters"
      assert Repo.get!(Filter, filter.id).lifespan == 3000
    end

    test "is not found for another user's filter", %{conn: conn, user: user} do
      other_filter = insert(:water_log_filter, lifespan: 1000)

      assert_error_sent(404, fn ->
        put(
          conn,
          ~p"/water-logs/#{other_filter.water_log_id}/filters/#{other_filter.id}?as=#{user.id}",
          filter: %{"lifespan" => "3000"}
        )
      end)

      assert Repo.get!(Filter, other_filter.id).lifespan == 1000
    end
  end

  describe "update/2 under a log the filter is not on" do
    test "is not found and leaves the filter alone", %{conn: conn, user: user, filter: filter} do
      other_log = insert(:water_log, user_id: user.id)
      lifespan = Repo.get!(Filter, filter.id).lifespan

      assert_error_sent(404, fn ->
        put(conn, ~p"/water-logs/#{other_log.id}/filters/#{filter.id}?as=#{user.id}",
          filter: %{"lifespan" => "3000"}
        )
      end)

      assert Repo.get!(Filter, filter.id).lifespan == lifespan
    end
  end

  describe "delete/2" do
    test "deletes the user's filter", %{conn: conn, user: user, log: log, filter: filter} do
      conn = delete(conn, ~p"/water-logs/#{log.id}/filters/#{filter.id}?as=#{user.id}")

      assert redirected_to(conn) == ~p"/water-logs/#{log.id}/filters"
      assert is_nil(Repo.get(Filter, filter.id))
    end

    test "is not found for another user's filter", %{conn: conn, user: user} do
      other_filter = insert(:water_log_filter)

      assert_error_sent(404, fn ->
        delete(
          conn,
          ~p"/water-logs/#{other_filter.water_log_id}/filters/#{other_filter.id}?as=#{user.id}"
        )
      end)

      assert Repo.get!(Filter, other_filter.id)
    end

    test "is not found under a log the filter is not on", %{
      conn: conn,
      user: user,
      filter: filter
    } do
      other_log = insert(:water_log, user_id: user.id)

      assert_error_sent(404, fn ->
        delete(conn, ~p"/water-logs/#{other_log.id}/filters/#{filter.id}?as=#{user.id}")
      end)

      assert Repo.get!(Filter, filter.id)
    end
  end
end
