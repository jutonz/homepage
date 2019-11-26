defmodule ClientWeb.FeatureHelpers do
  use Wallaby.DSL
  import Wallaby.Query, only: [css: 2]

  def role(role, opts \\ []),
    do: role |> role_selector() |> css(opts)

  defp role_selector(role),
    do: "[data-role=\"#{role}\"]"
end
