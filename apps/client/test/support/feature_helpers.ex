defmodule ClientWeb.FeatureHelpers do
  use Wallaby.DSL
  import Wallaby.Query, only: [css: 2]

  #def click_role(session, role),
    #do: click(session, find_role(session, role))

  def role(role, opts \\ []),
    do: role |> role_selector() |> css(opts)

  defp role_selector(role),
    do: "[data-role=#{role}]"
end
