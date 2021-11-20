defmodule ClientWeb.Plugs.VerifyTwitchCallbackTest do
  use ClientWeb.ConnCase, async: true
  alias ClientWeb.Plugs.VerifyTwitchCallback
  alias Twitch.Eventsub.Subscriptions

  test "halts an invalid request", %{conn: conn} do
    conn = VerifyTwitchCallback.call(conn, %{})
    assert conn.status == 400
  end

  test "verifies the request", %{conn: conn} do
    conn =
      conn
      |> put_req_header("twitch-eventsub-message-id", "a")
      |> put_req_header("twitch-eventsub-message-timestamp", "b")
      |> put_req_header("twitch-eventsub-message-signature", signature("abc"))
      |> assign(:raw_body, ["c"])

    conn = VerifyTwitchCallback.call(conn, %{})

    refute conn.status
  end

  defp signature(message) do
    Subscriptions.calculate_signature(message)
  end
end
