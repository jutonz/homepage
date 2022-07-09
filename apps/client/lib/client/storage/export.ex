defmodule Client.Storage.Export do
  alias Client.{
    Repo,
    Storage.Item,
    Storage.ItemQuery
  }

  @headers ~w[id name location unpacked_at description]a
  @fields_to_export ~w[id name location unpacked_at description]a
  def perform(context) do
    Item
    |> ItemQuery.by_user_id(context.creator_id)
    |> ItemQuery.by_context_id(context.id)
    |> ItemQuery.select(@fields_to_export)
    |> Repo.all()
    |> Enum.map(&extract_fields/1)
    |> put_headers()
    |> NimbleCSV.Spreadsheet.dump_to_iodata()
  end

  defp extract_fields(item) do
    [
      to_string(item.id),
      item.name,
      item.location,
      parse_date(item.unpacked_at),
      item.description
    ]
  end

  defp parse_date(nil), do: nil

  defp parse_date(date) do
    date
    |> DateTime.truncate(:second)
    |> DateTime.to_iso8601()
  end

  defp put_headers(rows) do
    [@headers | rows]
  end
end
