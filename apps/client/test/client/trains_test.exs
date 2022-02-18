defmodule Client.TrainsTest do
  use Client.DataCase, async: true
  alias Client.Trains

  describe "create_engine/1" do
    test "creates an engine" do
      user = insert(:user)
      params = params_for(:train_engine, user_id: user.id)

      {:ok, train} = Trains.create_engine(params)

      assert train.number == params[:number]
    end
  end

  describe "get_engine_by_number/1" do
    test "returns an engine" do
      user = insert(:user)
      %{number: number} = insert(:train_engine, user_id: user.id)

      engine = Trains.get_engine_by_number(number)

      assert engine.number == number
    end
  end

  describe "list_logs/1" do
    test "returns all of a user's logs" do
      user = insert(:user)
      log = insert(:train_log, user_id: user.id)
      _not_my_log = insert(:train_log, user_id: insert(:user).id)

      logs = user.id |> Trains.list_logs() |> Enum.map(& &1.id)

      assert ^logs = [log.id]
    end
  end

  describe "create_log/1" do
    test "it creates a train log" do
      user = insert(:user)
      params = params_for(:train_log, user_id: user.id)

      {:ok, log} = Trains.create_log(params)

      assert log.user_id == user.id
      assert log.location == params[:location]
    end

    test "doesn't allow a user to duplicate a location" do
      user = insert(:user)
      params = params_for(:train_log, user_id: user.id)
      {:ok, _log} = Trains.create_log(params)

      {:error, changeset} = Trains.create_log(params)

      expected = %{location: ["has already been taken"]}
      assert ^expected = errors_on(changeset)
    end
  end

  describe "get_log/2" do
    test "returns a user's log" do
      user = insert(:user)
      log = insert(:train_log, user_id: user.id)

      assert Trains.get_log(user.id, log.id)
    end

    test "doesn't return another user's log" do
      [user1, user2] = insert_pair(:user)
      log = insert(:train_log, user_id: user1.id)

      refute Trains.get_log(user2.id, log.id)
    end
  end
end
