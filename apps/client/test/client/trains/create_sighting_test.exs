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
        |> Map.put(:numbers, [engine.number])
        |> Map.put(:user_id, user.id)

      {:ok, sighting} = Trains.create_sighting(params)

      assert sighting.cars == params[:cars]
      assert sighting.direction == params[:direction]

      {:ok, naive_sighted_at} = NaiveDateTime.new(params[:sighted_date], params[:sighted_time])

      sighted_at =
        naive_sighted_at
        |> DateTime.from_naive!("America/New_York")
        |> DateTime.shift_zone!("Etc/UTC")
        |> DateTime.truncate(:second)

      assert sighting.sighted_at == sighted_at
    end

    test "creates a sighting for a new engine" do
      user = insert(:user)
      log = insert(:train_log, user_id: user.id)
      engine_number = rand_int()

      params =
        :train_sighting
        |> params_for(log_id: log.id)
        |> Map.put(:numbers, [engine_number])
        |> Map.put(:user_id, user.id)

      {:ok, _sighting} = Trains.create_sighting(params)

      assert Trains.get_engine_by_number(engine_number)
    end

    test "creates an engine_sighting for each engine" do
      user = insert(:user)
      log = insert(:train_log, user_id: user.id)
      engine_number1 = rand_int()
      engine_number2 = rand_int()

      params =
        :train_sighting
        |> params_for(log_id: log.id)
        |> Map.put(:numbers, [engine_number1, engine_number2])
        |> Map.put(:user_id, user.id)

      {:ok, sighting} = Trains.create_sighting(params)

      sighting = sighting |> Repo.preload(:engines)
      engine_numbers = Enum.map(sighting.engines, & &1.number)
      assert engine_number1 in engine_numbers
      assert engine_number2 in engine_numbers
    end
  end
end
