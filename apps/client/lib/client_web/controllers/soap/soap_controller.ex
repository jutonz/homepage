defmodule ClientWeb.Soap.SoapController do
  use ClientWeb, :controller

  plug :put_view, ClientWeb.Soap.SoapView

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
