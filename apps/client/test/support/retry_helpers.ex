defmodule Client.RetryHelpers do
  def wait_until(0, fun),
    do: fun.()

  def wait_until(timeout, fun) do
    try do
      fun.()
    rescue
      ExUnit.AssertionError ->
        :timer.sleep(100)
        wait_until(max(0, timeout - 100), fun)
    end
  end
end
