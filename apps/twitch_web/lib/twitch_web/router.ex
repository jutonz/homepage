defmodule TwitchWeb.Router do
  use TwitchWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(Phoenix.LiveView.Flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/", TwitchWeb do
    pipe_through(:browser)

    get("/hi", PageController, :index)
    get("/channels/:name", ChannelController, :show)
  end

  pipeline :api do
  end

  scope "/api", TwitchWeb do
    pipe_through(:api)
    get("/hi", PageController, :index)
  end
end
