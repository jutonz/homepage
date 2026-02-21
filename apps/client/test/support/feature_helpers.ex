defmodule ClientWeb.FeatureHelpers do
  use Wallaby.DSL
  import Wallaby.Query

  def role(role, opts \\ []) do
    %Wallaby.Query{} = role |> role_selector() |> css(opts)
  end

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

  def wait_for_hash_path(session, path, time \\ DateTime.utc_now()) do
    current_path = hash_path(session)

    cond do
      current_path == path ->
        session

      reached_timeout?(time) ->
        raise "never reached path #{path}"

      true ->
        :timer.sleep(500)
        wait_for_hash_path(session, path, time)
    end
  end

  def reached_timeout?(time, timeout \\ 10) do
    DateTime.diff(DateTime.utc_now(), time, :second) > timeout
  end

  # wait for the given function to return {:ok, result}
  def wait_for_condition(timeout_in_seconds, fun, time \\ DateTime.utc_now()) do
    case fun.() do
      {:ok, result} ->
        result

      _ ->
        cond do
          reached_timeout?(time, timeout_in_seconds) ->
            raise "function never returned {:ok, result}"

          true ->
            wait_for_condition(timeout_in_seconds, fun, time)
        end
    end
  end
end
