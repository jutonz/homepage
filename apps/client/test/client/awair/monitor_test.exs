defmodule Client.Awair.MonitorTest do
  use Client.DataCase, async: true

  alias Client.Awair.{
    AirData,
    Monitor
  }

  test "broadcasts awair data" do
    :ok = Phoenix.PubSub.subscribe(Client.PubSub, "awair")

    event_body = %{
      "co2" => 600,
      "timestamp" => "2024-06-01T12:00:00Z"
    }

    Req.Test.stub(AirData, fn %{request_path: "/air-data/latest"} = conn ->
      Req.Test.json(conn, event_body)
    end)

    {:ok, pid} = GenServer.start_link(Monitor, test_server())
    Req.Test.allow(AirData, self(), pid)
    send(pid, :poll)

    event = %{
      data: AirData.from_json(event_body),
      name: "test"
    }

    assert_receive(^event, 1000)
  end

  defp test_server do
    %{name: "test", host: "http://localhost"}
  end
end
