defmodule ClientWeb.Twitch.ChannelController do
  use ClientWeb, :controller

  def show(conn, %{"name" => name} = params) do
    conn |> render("test.html", name: name)
  end
end
