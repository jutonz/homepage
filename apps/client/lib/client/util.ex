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
end
