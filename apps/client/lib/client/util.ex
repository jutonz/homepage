defmodule Client.Util do
  @spec errors_to_sentence(Ecto.Changeset.t()) :: String.t()
  def errors_to_sentence(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
