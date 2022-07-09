defmodule ClientWeb.Storage.ExportControllerTest do
  use ClientWeb.ConnCase, async: true

  describe "create/2" do
    test "exports a context", %{conn: conn} do
      creator = insert(:user)
      context = insert(:storage_context, creator: creator)
      now = DateTime.utc_now() |> DateTime.truncate(:second)

      item =
        insert(:storage_item, %{
          context: context,
          description: "here's what I stored",
          unpacked_at: now
        })

      resp =
        post(conn, Routes.storage_context_export_path(conn, :create, context, as: creator.id))

      assert resp.status == 200

      exported_item =
        resp.resp_body
        |> NimbleCSV.Spreadsheet.parse_string()
        |> Enum.at(0)

      assert Enum.at(exported_item, 0) == to_string(item.id)
    end
  end
end
