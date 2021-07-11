defmodule ClientWeb.TrainLogLiveTest do
  use ClientWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "it redirects if the log can't be found", %{conn: conn} do
    user = insert(:user)
    path = Routes.train_log_path(conn, :show, 123, as: user.id)
    redirect_path = Routes.train_log_path(conn, :index)

    assert {:error, {:redirect, %{to: ^redirect_path}}} = live(conn, path)
  end
end
