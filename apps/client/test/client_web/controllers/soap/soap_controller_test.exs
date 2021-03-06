defmodule ClientWeb.Soap.SoapControllerTest do
  use ClientWeb.ConnCase, async: true
  alias Client.Factory

  describe "index" do
    test "includes a link to batches", %{conn: conn} do
      user = Factory.insert(:user)

      conn
      |> get(Routes.soap_soap_path(conn, :index), as: user.id)
      |> parsed_html_response(200)
      |> assert_contains_selector("a[href='#{Routes.soap_batch_path(conn, :index)}']")
    end

    test "includes a link to orders", %{conn: conn} do
      user = Factory.insert(:user)

      conn
      |> get(Routes.soap_soap_path(conn, :index), as: user.id)
      |> parsed_html_response(200)
      |> assert_contains_selector("a[href='#{Routes.soap_order_path(conn, :index)}']")
    end
  end
end
