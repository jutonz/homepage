defmodule Client.Awair.AirDataTest do
  use Client.DataCase, async: true
  alias Client.Awair.AirData

  describe "latest/1" do
    test "returns air data" do
      json = %{
        "abs_humid" => 11.39,
        "co2" => 1191,
        "co2_est" => 410,
        "co2_est_baseline" => 33907,
        "dew_point" => 13.62,
        "humid" => 55.64,
        "pm10_est" => 2,
        "pm25" => 1,
        "score" => 86,
        "temp" => 22.96,
        "timestamp" => "2024-05-04T12:44:50Z",
        "voc" => 185,
        "voc_baseline" => 36191,
        "voc_ethanol_raw" => 35,
        "voc_h2_raw" => 24
      }

      Req.Test.stub(AirData, fn %{request_path: "/air-data/latest"} = conn ->
        Req.Test.json(conn, json)
      end)

      {:ok, airdata} = AirData.latest("http://localhost")

      {:ok, timestamp, _} = DateTime.from_iso8601(json["timestamp"])

      expected = %AirData{
        abs_humid: json["abs_humid"],
        co2: trunc(json["co2"]),
        co2_est: json["co2_est"],
        co2_est_baseline: json["co2_est_baseline"],
        dew_point: json["dew_point"],
        humid: json["humid"],
        pm10_est: json["pm10_est"],
        pm25: json["pm25"],
        score: json["score"],
        temp: json["temp"],
        timestamp: timestamp,
        voc: json["voc"],
        voc_baseline: json["voc_baseline"],
        voc_ethanol_raw: json["voc_ethanol_raw"],
        voc_h2_raw: json["voc_h2_raw"]
      }

      assert airdata == expected
    end
  end

  describe "from_json/1" do
    test "converts the map into a struct" do
      json = %{"co2" => 123}
      expected = %AirData{co2: 123}

      actual = AirData.from_json(json)

      assert actual == expected
    end
  end
end
