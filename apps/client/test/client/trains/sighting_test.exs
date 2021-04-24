defmodule Client.Trains.SightingTest do
  use Client.DataCase, async: true
  alias Client.Trains.Sighting

  describe "changeset/2" do
    test "direction must be North or South" do
      params = params_for(:train_sighting, direction: "blah")

      changeset = Sighting.changeset(%Sighting{}, params)
      errors = errors_on(changeset)

      assert errors[:direction] == ["must be North or South"]
    end

    test "combines sighted_date and sighted_time into sighted_at" do
      now = DateTime.now!("America/New_York")
      date = DateTime.to_date(now)
      time = DateTime.to_time(now)
      params = params_for(:train_sighting, sighted_date: date, sighted_time: time)

      changeset = Sighting.changeset(%Sighting{}, params)

      expected =
        now
        |> DateTime.shift_zone!("Etc/UTC")
        |> DateTime.truncate(:second)

      assert Ecto.Changeset.get_change(changeset, :sighted_at) == expected
    end
  end
end
