defmodule ClientWeb.FeatureHelpers do
  use Wallaby.DSL
  import Wallaby.Query

  def role(role, opts \\ []),
    do: role |> role_selector() |> css(opts)

  defp role_selector(role),
    do: "[data-role=\"#{role}\"]"

  def login(session, user) do
    session
    |> visit("/#/login")
    |> fill_in(fillable_field("email"), with: user.email)
    |> fill_in(fillable_field("password"), with: user.password)
    |> click(button("Login", disabled: false))
    |> find(css("a", text: "Logout"))

    session
  end

  def hash_path(session) do
    execute_script_sync(session, "return window.location.hash")
  end

  def execute_script_sync(%{driver: driver} = session, script) do
    {:ok, value} = driver.execute_script(session, script, [])
    value
  end
end
