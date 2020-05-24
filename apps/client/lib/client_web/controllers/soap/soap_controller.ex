defmodule ClientWeb.Soap.SoapController do
  use ClientWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
