defmodule Client.Trains.CreateSightingTest do
  use Client.DataCase, async: true
  alias Client.Trains

  describe "create_sighting/1" do
    test "creates a sighting for an existing engine" do
      user = insert(:user)
      log = insert(:train_log, user_id: user.id)
      engine = insert(:train_engine, user_id: user.id)

      params =
        :train_sighting
        |> params_for(log_id: log.id)
        |> Map.put(:number, engine.number)
        |> Map.put(:user_id, user.id)

      {:ok, sighting} = Trains.create_sighting(params)

      assert sighting.cars == params[:cars]
      assert sighting.direction == params[:direction]
      assert sighting.sighted_at == params[:sighted_at]
    end

    test "creates a sighting for a new engine" do
      user = insert(:user)
      log = insert(:train_log, user_id: user.id)
      engine_number = rand_int()

      params =
        :train_sighting
        |> params_for(log_id: log.id)
        |> Map.put(:number, engine_number)
        |> Map.put(:user_id, user.id)

      {:ok, _sighting} = Trains.create_sighting(params)

      assert Trains.get_engine_by_number(engine_number)
    end
  end
end
