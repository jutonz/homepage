defmodule Client.ErrorHelpers do
  def extract_changest_errors(%Ecto.Changeset{} = changeset) do
    changeset.errors
    |> Enum.map(fn error ->
      attr = error |> elem(0) |> to_string |> String.capitalize()
      message = error |> elem(1) |> elem(0)
      "#{attr} #{message}"
    end)
  end
end
