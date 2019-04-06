defmodule ClientWeb.Twitch.ChannelController do
  use ClientWeb, :controller

  def test(conn, _params) do
    conn |> render("test.html")
  end
end
