defmodule ClientWeb.FeatureHelpers do
  use Wallaby.DSL

  import Wallaby.Query,
    only: [
      button: 1,
      css: 2,
      fillable_field: 1
    ]

  def role(role, opts \\ []),
    do: role |> role_selector() |> css(opts)

  defp role_selector(role),
    do: "[data-role=\"#{role}\"]"

  def login(session, user) do
    session
    |> visit("/#/login")
    |> fill_in(fillable_field("email"), with: user.email)
    |> fill_in(fillable_field("password"), with: user.password)
    |> click(button("Login"))
    |> find(css("a", text: "Logout"))
  end
end
