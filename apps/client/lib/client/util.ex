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

  @spec format_number(number() | float()) :: String.t()

  def format_number(number) when is_float(number) do
    [number, decimal] =
      number
      |> Float.to_string()
      |> String.split(".")

    number =
      with {number, _rem} <- Integer.parse(number) do
        format_number(number)
      end

    decimal =
      with {decimal, _rem} <- Float.parse("0.#{decimal}") do
        decimal |> Float.round(1) |> Float.to_string() |> String.slice(1..-1//1)
      end

    number <> decimal
  end

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
