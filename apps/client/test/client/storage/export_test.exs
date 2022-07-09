defmodule Client.Storage.ExportTest do
  use Client.DataCase, async: true

  alias Client.{
    Storage.Export
  }

  describe "perform/1" do
    test "exports data" do
      creator = insert(:user)
      context = insert(:storage_context, creator: creator)
      now = DateTime.utc_now() |> DateTime.truncate(:second)

      item =
        insert(:storage_item, %{
          context: context,
          description: "here's what I stored",
          unpacked_at: now
        })

      csv = context |> Export.perform() |> parse_csv_iodata()

      row = Enum.at(csv, 0)
      assert Enum.at(row, 0) == to_string(item.id)
      assert Enum.at(row, 1) == item.name
      assert Enum.at(row, 2) == item.location
      assert Enum.at(row, 3) == DateTime.to_iso8601(now)
      assert Enum.at(row, 4) == item.description
    end
  end

  defp parse_csv_iodata(iodata) do
    iodata
    |> IO.iodata_to_binary()
    |> NimbleCSV.Spreadsheet.parse_string()
  end
end
