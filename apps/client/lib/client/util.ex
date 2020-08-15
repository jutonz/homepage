defmodule Client.Util do
  @spec attribute_errors(Ecto.Changeset.t()) :: %{required(atom()) => list(String.t())}
  def attribute_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  def errors_to_sentence(changeset) do
    changeset
    |> attribute_errors()
    |> Map.to_list()
    |> Enum.map(fn {attr, errors} ->
      "#{attr} #{Enum.join(errors, ", ")}"
    end)
    |> Enum.join(", ")
  end

  @spec format_number(number()) :: String.t()
  def format_number(number) do
    number
    |> Integer.to_string()
    |> String.graphemes()
    |> Enum.reverse()
    |> Stream.chunk_every(3)
    |> Enum.join(",")
    |> String.reverse()
  end
end
