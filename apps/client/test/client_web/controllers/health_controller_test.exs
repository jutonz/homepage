defmodule ClientWeb.HealthControllerTest do
  use ClientWeb.ConnCase

  test "GET /healthz", %{conn: conn} do
    conn = get conn, "/api/healthz"
    assert response(conn, 200) == ""
  end
end
