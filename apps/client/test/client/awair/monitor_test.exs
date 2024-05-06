defmodule Client.Awair.MonitorTest do
  use Client.DataCase, async: true

  alias Client.Awair.{
    AirData,
    Monitor
  }

  test "broadcasts awair data" do
    :ok = Phoenix.PubSub.subscribe(Client.PubSub, "awair")
    json = %{"co2" => 600}

    Req.Test.stub(AirData, fn %{request_path: "/air-data/latest"} = conn ->
      Req.Test.json(conn, json)
    end)

    {:ok, pid} = GenServer.start_link(Monitor, test_server())
    Req.Test.allow(AirData, self(), pid)
    send(pid, :poll)

    event = %{
      data: AirData.from_json(json),
      name: "test"
    }

    assert_receive ^event
  end

  defp test_server do
    %{name: "test", host: "http://localhost"}
  end
end
