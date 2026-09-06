defmodule ClientWeb.FoodLogControllerTest do
  use ClientWeb.ConnCase, async: true

  alias Client.FoodLogs.FoodLog
  alias Client.Repo

  setup do
    user = insert(:user)
    %{user: user, log: insert(:food_log, owner_id: user.id)}
  end

  describe "index/2" do
    test "lists only the user's logs", %{conn: conn, user: user, log: log} do
      other_log = insert(:food_log)

      html = conn |> get(~p"/food-logs?as=#{user.id}") |> html_response(200)

      assert html =~ log.name
      refute html =~ other_log.name
    end
  end

  describe "create/2" do
    test "takes the owner from the session", %{conn: conn, user: user} do
      other = insert(:user)
      params = %{"name" => "supper", "owner_id" => other.id}

      conn = post(conn, ~p"/food-logs?as=#{user.id}", food_log: params)

      log = Repo.get_by!(FoodLog, name: "supper")
      assert log.owner_id == user.id
      assert redirected_to(conn) == ~p"/food-logs/#{log.id}"
    end
  end

  describe "edit/2" do
    test "renders the user's log", %{conn: conn, user: user, log: log} do
      html = conn |> get(~p"/food-logs/#{log.id}/edit?as=#{user.id}") |> html_response(200)

      assert html =~ log.name
    end

    test "is not found for another user's log", %{conn: conn, user: user} do
      other_log = insert(:food_log)

      assert_error_sent(404, fn ->
        get(conn, ~p"/food-logs/#{other_log.id}/edit?as=#{user.id}")
      end)
    end
  end

  describe "update/2" do
    test "updates the user's log", %{conn: conn, user: user, log: log} do
      conn =
        put(conn, ~p"/food-logs/#{log.id}?as=#{user.id}", food_log: %{"name" => "new name"})

      assert redirected_to(conn) == ~p"/food-logs/#{log.id}"
      assert Repo.get(FoodLog, log.id).name == "new name"
    end

    test "is not found for another user's log", %{conn: conn, user: user} do
      other_log = insert(:food_log)

      assert_error_sent(404, fn ->
        put(conn, ~p"/food-logs/#{other_log.id}?as=#{user.id}", food_log: %{"name" => "mine now"})
      end)

      assert Repo.get(FoodLog, other_log.id).name == other_log.name
    end
  end

  describe "delete/2" do
    test "deletes the user's log", %{conn: conn, user: user, log: log} do
      conn = delete(conn, ~p"/food-logs/#{log.id}?as=#{user.id}")

      assert redirected_to(conn) == ~p"/food-logs"
      refute Repo.get(FoodLog, log.id)
    end

    test "is not found for another user's log", %{conn: conn, user: user} do
      other_log = insert(:food_log)

      assert_error_sent(404, fn ->
        delete(conn, ~p"/food-logs/#{other_log.id}?as=#{user.id}")
      end)

      assert Repo.get(FoodLog, other_log.id)
    end
  end
end
