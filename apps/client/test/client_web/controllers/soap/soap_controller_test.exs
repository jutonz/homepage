defmodule ClientWeb.Soap.SoapControllerTest do
  use ClientWeb.ConnCase, async: true
  alias Client.Factory

  describe "index" do
    test "includes a link to batches", %{conn: conn} do
      user = Factory.insert(:user)

      conn
      |> get(soap_soap_path(conn, :index), as: user.id)
      |> html_response(200)
      |> assert_contains("a[href='#{soap_batch_path(conn, :index)}']")
    end

    test "includes a link to orders", %{conn: conn} do
      user = Factory.insert(:user)

      conn
      |> get(soap_soap_path(conn, :index), as: user.id)
      |> html_response(200)
      |> assert_contains("a[href='#{soap_order_path(conn, :index)}']")
    end
  end
end
