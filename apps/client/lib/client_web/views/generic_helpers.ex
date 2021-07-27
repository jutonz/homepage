defmodule ClientWeb.GenericHelpers do
  def existential_checkmark(value) do
    case value do
      nil -> ""
      _ -> "✓"
    end
  end
end
